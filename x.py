#!/usr/bin/env python3

import abc
import argparse
import docker
import json
import os
import subprocess
import yaml

COMMANDS = {}


def command(name, help_text):
    """
    Decorator used to register a command. Put this on a subclass of Command to
    make it usable.
    """

    def inner(cls):
        if name in COMMANDS:
            raise ValueError(
                "Cannot register '{}' under '{}'."
                " '{}' is already registered under that name.".format(
                    cls, name, COMMANDS[name]
                )
            )
        cls._NAME = name
        cls._HELP_TEXT = help_text
        COMMANDS[name] = cls()
        return cls

    return inner


class Command(metaclass=abc.ABCMeta):
    @property
    def name(self):
        return self._NAME

    @property
    def help_text(self):
        return self._HELP_TEXT

    def configure_parser(self, parser):
        pass

    @abc.abstractmethod
    def run(self, *args, **kwargs):
        pass


def load_env(env_file):
    with open(env_file) as f:
        return json.load(f)


def run_cmd(cmd, env={}):
    """
    Runs the given shell command
    Arguments:
        cmd {[str]} -- The command, as a list of arguments
    """
    print(
        "+ {env} {cmd}".format(
            cmd=" ".join(cmd),
            env=" ".join(f"{key}={val}" for key, val in env.items()),
        )
    )

    return subprocess.run(cmd, check=True, env={**env, **os.environ})


@command(
    "gencert",
    "Generate a self-signed SSL cert and copy it into a docker volume",
)
class GenCert(Command):
    TMP_CONTAINER = "certs"

    def configure_parser(self, parser):
        parser.add_argument(
            "--volume",
            default="keskne_keskne-certs",
            help="The docker volume to copy the cert into",
        )

    def run(self, env_file, volume, **kwargs):
        env = load_env(env_file)
        domain = env["ROOT_HOSTNAME"]  # domain to gen a cert for
        run_cmd(
            [
                "openssl",
                "req",
                "-x509",
                "-nodes",
                "-days",
                "365",
                "-newkey",
                "rsa:2048",
                "-keyout",
                "privkey.pem",
                "-out",
                "fullchain.pem",
                "-subj",
                f"/CN={domain}/",
            ]
        )

        run_cmd(
            [
                "docker",
                "run",
                "-d",
                "--rm",
                "--name",
                self.TMP_CONTAINER,
                "-v",
                f"{volume}:/app/certs:rw",
                "alpine",
                "tail",
                "-f",
                "/dev/null",
            ]
        )

        try:
            dest_path = f"/app/certs/{domain}/"
            cp_dest = f"{self.TMP_CONTAINER}:{dest_path}"
            run_cmd(
                ["docker", "exec", self.TMP_CONTAINER, "mkdir", "-p", dest_path]
            )
            run_cmd(["docker", "cp", "privkey.pem", cp_dest])
            run_cmd(["docker", "cp", "fullchain.pem", cp_dest])
        finally:
            run_cmd(["docker", "stop", "-t", "0", self.TMP_CONTAINER])
            run_cmd(["rm", "privkey.pem", "fullchain.pem"])


@command("build", "Build and (optionally) push local Keskne images")
class Build(Command):
    def configure_parser(self, parser):
        parser.add_argument(
            "services",
            nargs="*",
            help="Services to build/push. Exclude for all.",
        )
        parser.add_argument(
            "--push",
            "-p",
            action="store_true",
            help="Push images after building",
        )

    def run(self, env_file, services, push, **kwargs):
        env = load_env(env_file)
        base_cmd = ["docker-compose", "-f", "docker-compose.build.yml"]
        run_cmd([*base_cmd, "build", "--pull", *services], env=env)
        if push:
            run_cmd([*base_cmd, "push", *services], env=env)


@command("clean", "Clean up docker stuff")
class Clean(Command):
    def run(self, **kwargs):
        run_cmd(["docker", "system", "prune", "-f"])


@command("secrets", "Insert docker secrets")
class Secrets(Command):

    PLACEHOLDER_VALUE = "hunter2"

    def configure_parser(self, parser):
        parser.add_argument(
            "--stack-config",
            "-c",
            default="docker-stack.yml",
            help="The docker stack config file to pull secrets from",
        )
        parser.add_argument(
            "--skip-existing",
            "-s",
            action="store_true",
            help="Skip any secret that already exists",
        )
        parser.add_argument(
            "--placeholder",
            action="store_true",
            help="Auto-fill all non-existing secrets with placeholder values",
        )

    def fmt_msg(self, secret_name, msg, show_name=True):
        if show_name:
            return f"[{secret_name}] {msg}"
        else:
            return "{{:>{}}} {}".format(len(secret_name) + 2, msg).format("")

    def run(self, stack_config, skip_existing, placeholder, **kwargs):
        with open(stack_config) as f:
            secrets = list(
                yaml.load(f, Loader=yaml.SafeLoader)["secrets"].keys()
            )

        client = docker.from_env()
        existing_secrets = {sec.name: sec for sec in client.secrets.list()}
        for secret_name in secrets:
            existing_secret = existing_secrets.get(secret_name)
            if existing_secret:
                skip = (
                    skip_existing
                    or placeholder
                    or input(
                        self.fmt_msg(
                            secret_name,
                            "Already exists, write new value? (y/N): ",
                        )
                    )
                    .strip()
                    .lower()
                    != "y"
                )
                if skip:
                    print(self.fmt_msg(secret_name, "Skipped", show_name=False))
                    continue

            # Use placeholder value or read from user
            if placeholder:
                print(self.fmt_msg(secret_name, f"= {self.PLACEHOLDER_VALUE}"))
                new_value = self.PLACEHOLDER_VALUE
            else:
                new_value = input(self.fmt_msg(secret_name, "= "))

            if new_value:
                if existing_secret:
                    existing_secret.remove()
                client.secrets.create(name=secret_name, data=new_value)
                print(self.fmt_msg(secret_name, "Set", show_name=False))
            else:
                print(self.fmt_msg(secret_name, "Skipped", show_name=False))


@command("deploy", "Deploy the stack")
class Deploy(Command):
    def configure_parser(self, parser):
        parser.add_argument(
            "--version-sha",
            "-s",
            default=run_cmd(["git", "rev-parse" "origin/master"]),
            help="Version of the helm chart to deploy"
            " (defaults to current master SHA)",
        )
        # TODO still need this?
        parser.add_argument(
            "--make-logs",
            action="store_true",
            help="Create log directories on the local machine",
        )

    def run(self, env_file, stack_name, stack_config, make_logs, **kwargs):
        env = load_env(env_file)
        if make_logs:
            logs_dir = env["KESKNE_LOGS_DIR"]
            for subdir in self.LOG_SUBDIRS:
                run_cmd(["mkdir", "-p", os.path.join(logs_dir, subdir)])
        run_cmd(
            ["docker", "stack", "deploy", "-c", stack_config, stack_name],
            env=env,
        )


def main():
    parser = argparse.ArgumentParser(
        description="Utility script for task execution"
    )
    parser.add_argument(
        "--env-file",
        "-e",
        default="env.json",
        help="The environment file to use (a JSON mapping)",
    )
    subparsers = parser.add_subparsers(
        help="sub-command help", dest="cmd", required=True
    )

    for command in COMMANDS.values():
        subparser = subparsers.add_parser(command.name, help=command.help_text)
        subparser.set_defaults(func=command.run)
        command.configure_parser(subparser)

    args = parser.parse_args()
    argd = vars(args)
    func = argd.pop("func")
    argd.pop("cmd")  # Don't need this one
    func(**argd)


if __name__ == "__main__":
    main()

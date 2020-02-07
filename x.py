#!/usr/bin/env python3

import abc
import argparse
import docker
import itertools
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
    def run(self, args):
        pass


def run_cmd(cmd, env={}):
    """
    Runs the given shell command
    Arguments:
        cmd {[str]} -- The command, as a list of arguments
    """
    print(
        "+ {} [{}]".format(
            " ".join(cmd), ", ".join(f"{key}={val}" for key, val in env.items())
        )
    )
    full_env = {**os.environ, **env}
    subprocess.run(cmd, check=True, env=full_env)


def run_in_docker_service(service, cmd, env={}):
    """
    Runs a command in the container corresponding to the given docker-compose
    service. This will turn the service into a container name, then run the cmd.
    """
    # create an iter of each env var, e.g. ['-e', 'k1=v1', '-e', 'k2=v2']
    env_vars = itertools.chain.from_iterable(
        ["-e", f"{k}={v}"] for k, v in env.items()
    )
    run_cmd(["docker", "exec", "-t", *env_vars, f"gdlk_{service}_1", *cmd])


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

    def run(self, services, push):
        base_cmd = ["docker-compose", "-f", "docker-compose.build.yml"]
        run_cmd([*base_cmd, "build", "--pull", *services])
        if push:
            run_cmd([*base_cmd, "push", *services])


@command("clean", "Clean up docker stuff")
class Clean(Command):
    def run(self):
        run_cmd(["docker", "system", "prune", "-f"])


@command("secrets", "Insert docker secrets")
class Secrets(Command):
    def configure_parser(self, parser):
        parser.add_argument("--docker-stack", "-d", default="docker-stack.yml")
        parser.add_argument("--skip-existing", "-s", action="store_true")

    def run(self, docker_stack, skip_existing):
        with open(docker_stack) as f:
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
                    or input(
                        f"[{secret_name}] Already exists, write new value? (y/N): "
                    )
                    .strip()
                    .lower()
                    != "y"
                )
                if skip:
                    print(f"[{secret_name}] Skipped")
                    continue
            new_value = input(f"[{secret_name}] = ")
            if new_value:
                if existing_secret:
                    existing_secret.remove()
                client.secrets.create(name=secret_name, data=new_value)
                print(f"[{secret_name}] Set")
            else:
                print(f"[{secret_name}] Skipped")


@command("deploy", "Deploy the stack")
class Deploy(Command):
    def configure_parser(self, parser):
        parser.add_argument(
            "--env-file",
            "-e",
            default="env.json",
            help="The environment file to use (a JSON mapping)",
        )
        parser.add_argument(
            "--stack-name",
            "-n",
            default="keskne",
            help="The name to use for the stack",
        )
        parser.add_argument(
            "--stack-config",
            "-c",
            default="docker-stack.yml",
            help="The YAML file that defines the stack to deploy",
        )

    def run(self, env_file, stack_name, stack_config):
        with open(env_file) as f:
            env = json.load(f)
        run_cmd(
            ["docker", "stack", "deploy", "-c", stack_config, stack_name],
            env=env,
        )


def main():
    parser = argparse.ArgumentParser(
        description="Utility script for task execution"
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

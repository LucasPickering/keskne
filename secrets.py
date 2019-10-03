#!/usr/bin/env python3

import argparse
import docker
import yaml


def main():
    parser = argparse.ArgumentParser(description="Insert docker secrets")
    parser.add_argument("--docker-stack", "-d", default="docker-stack.yml")
    parser.add_argument("--skip-existing", "-s", action="store_true")
    args = parser.parse_args()

    with open(args.docker_stack) as f:
        secrets = list(yaml.load(f)["secrets"].keys())

    client = docker.from_env()
    existing = {sec.name for sec in client.secrets.list()}
    for secret in secrets:
        if secret in existing:
            skip = (
                args.skip_existing
                or input(f"[{secret}] Already exists, write new value? (y/N): ")
                .strip()
                .lower()
                != "y"
            )
            if skip:
                print(f"[{secret}] Skipped")
                continue
        new_value = input(f"[{secret}] = ")
        if new_value:
            client.secrets.create(name=secret, data=new_value)
            print(f"[{secret}] Set")
        else:
            print(f"[{secret}] Skipped")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3

import argparse
from pathlib import Path

import tomli_w
import yaml


def parse_agent(source: Path) -> tuple[dict[str, object], str]:
    lines = source.read_text().splitlines(keepends=True)
    if not lines or lines[0].strip() != "---":
        raise ValueError(f"{source} must start with YAML frontmatter")

    try:
        closing_delimiter = next(
            index for index, line in enumerate(lines[1:], start=1) if line.strip() == "---"
        )
    except StopIteration as error:
        raise ValueError(f"{source} has unterminated YAML frontmatter") from error

    metadata = yaml.safe_load("".join(lines[1:closing_delimiter]))
    if not isinstance(metadata, dict):
        raise ValueError(f"{source} frontmatter must be a YAML mapping")

    return metadata, "".join(lines[closing_delimiter + 1 :])


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    metadata, body = parse_agent(args.source)
    name = metadata.get("name")
    description = metadata.get("description", metadata.get("role"))

    if not isinstance(name, str) or not name.strip():
        raise ValueError(f"{args.source} must define a non-empty name")
    if not isinstance(description, str) or not description.strip():
        raise ValueError(f"{args.source} must define a non-empty description or role")
    if not body.strip():
        raise ValueError(f"{args.source} must contain agent instructions")

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("wb") as output:
        tomli_w.dump(
            {
                "name": name,
                "description": description,
                "developer_instructions": body,
            },
            output,
            multiline_strings=True,
        )


if __name__ == "__main__":
    main()

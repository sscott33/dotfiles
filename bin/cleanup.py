#!/usr/bin/python3

from argparse import ArgumentParser
from pathlib import Path


def cli():
    ap = ArgumentParser(
        description="A simple program to remove non-printable characters from a file. Not compatible with files that use tab characters."
    )
    ap.add_argument("input_file", type=Path, help="the file in need of cleaning")
    ap.add_argument("output_file", type=Path, help="a clean copy of the input file")

    return ap.parse_args()


opts = cli()

with opts.input_file.open() as input_fh, opts.output_file.open(mode="w") as output_fh:
    for line in input_fh:
        output_fh.write("".join(c for c in line if c.isprintable()) + "\n")

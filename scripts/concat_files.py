#!/usr/bin/env python3

import argparse
import sys
from pathlib import Path


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Concatenate multiple text files into a single file with separators."
    )
    parser.add_argument("files", nargs="+", type=str, help="Text files to concatenate")
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        default="output.txt",
        help="Output file name (default: output.txt)",
    )
    return parser.parse_args()


def concatenate_files(input_files, output_file):
    separator = "-" * 20 + "\n"

    with open(output_file, "w") as outfile:
        for i, file_path in enumerate(input_files):
            try:
                with open(file_path, "r") as infile:
                    # Write separator before content (except for the first file)
                    if i > 0:
                        outfile.write("\n" + separator + "\n")

                    # Copy content
                    outfile.write(infile.read().rstrip("\n") + "\n")

            except Exception as e:
                print(f"Error reading file '{file_path}': {str(e)}", file=sys.stderr)
                continue


def main():
    args = parse_arguments()

    # Convert input files to Path objects and verify they exist
    input_files = [str(Path(f).resolve()) for f in args.files]
    output_file = Path(args.output).resolve()

    # Create output directory if it doesn't exist
    output_file.parent.mkdir(parents=True, exist_ok=True)

    try:
        concatenate_files(input_files, output_file)
        print(f"Successfully created: {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

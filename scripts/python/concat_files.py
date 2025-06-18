#!/usr/bin/env python3

import argparse  # For handling command line arguments
import sys  # For system operations like exit and stderr
from pathlib import Path  # For cross-platform path handling


def parse_arguments():
    """Set up and parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Concatenate multiple text files into a single file with separators."
    )
    # Required: List of files to process
    parser.add_argument(
        "files",
        nargs="+",  # '+' means at least one file is required
        type=str,
        help="Text files to concatenate",
    )
    # Optional: Output file name
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        default="output.txt",
        help="Output file name (default: output.txt)",
    )
    return parser.parse_args()


def concatenate_files(input_files, output_file):
    """Combine multiple files into one with separators between them"""
    separator = "-" * 20 + "\n"  # Create a line of 20 dashes

    with open(output_file, "w") as outfile:  # 'w' mode creates/overwrites the file
        for i, file_path in enumerate(input_files):
            try:
                with open(file_path, "r") as infile:
                    # Add separator before each file except the first one
                    if i > 0:
                        outfile.write("\n" + separator + "\n")

                    # Write the file name
                    file_name = Path(file_path).name
                    outfile.write(f"File: {file_name}\n\n")

                    # Read and write file content, ensure it ends with newline
                    outfile.write(infile.read().rstrip("\n") + "\n")

            except Exception as e:
                # If there's an error, print it but continue processing other files
                print(f"Error reading file '{file_path}': {str(e)}", file=sys.stderr)
                continue


def main():
    """Main function that orchestrates the file concatenation process"""
    args = parse_arguments()

    # Convert file paths to absolute paths
    input_files = [str(Path(f).resolve()) for f in args.files]
    output_file = Path(args.output).resolve()

    # Ensure output directory exists
    output_file.parent.mkdir(parents=True, exist_ok=True)

    try:
        concatenate_files(input_files, output_file)
        print(f"Successfully created: {output_file}")
    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)  # Exit with error code 1 if something goes wrong


if __name__ == "__main__":
    main()

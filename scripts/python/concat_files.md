# concat_files.py

A command-line tool that concatenates multiple text files into a single output file.

## Features

- Combines multiple text files into a single file
- Separates content from different files with clear dividers
- Continues processing even if some files can't be read
- Maintains the original order of files
- Customizable output filename

## Usage

```bash
# Basic usage (creates output.txt by default)
./concat_files.py file1.txt file2.txt file3.txt

# Specify custom output file
./concat_files.py -o custom_output.txt file1.txt file2.txt file3.txt

# Using wildcards (shell expansion)
./concat_files.py *.txt

# Help
./concat_files.py --help
```

## Output Format

The tool combines files with a clear separator between each file's content:

```
Content of first file...

--------------------

Content of second file...

--------------------

Content of third file...
```

## Error Handling

- If a file cannot be read (e.g., permission issues or file doesn't exist), the tool will:
  - Display an error message for that specific file
  - Continue processing the remaining files
  - Include successfully read files in the output

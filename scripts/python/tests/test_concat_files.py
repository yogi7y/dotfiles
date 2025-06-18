import pytest
import os
import tempfile
from pathlib import Path
import sys

# Add the parent directory to Python path so we can import our module
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from concat_files import concatenate_files


@pytest.fixture
def test_files():
    # Create a temporary directory for test files
    test_dir = tempfile.mkdtemp()

    # Create test input files
    file1_path = Path(test_dir) / "file1.txt"
    file2_path = Path(test_dir) / "file2.txt"
    output_path = Path(test_dir) / "output.txt"

    # Write test content
    file1_path.write_text("Content of file 1\nSecond line")
    file2_path.write_text("Content of file 2")

    yield {
        "dir": test_dir,
        "file1": file1_path,
        "file2": file2_path,
        "output": output_path,
    }

    # Clean up test files
    for file in [file1_path, file2_path, output_path]:
        if file.exists():
            file.unlink()
    os.rmdir(test_dir)


def test_basic_concatenation(test_files):
    """Test basic file concatenation with two files"""
    input_files = [str(test_files["file1"]), str(test_files["file2"])]
    concatenate_files(input_files, str(test_files["output"]))

    # Read the output and verify
    output_content = test_files["output"].read_text()
    expected = (
        "File: file1.txt\n\n"
        "Content of file 1\nSecond line\n\n"
        "--------------------\n\n"
        "File: file2.txt\n\n"
        "Content of file 2\n"
    )
    assert output_content == expected


def test_missing_file(test_files):
    """Test handling of missing files"""
    non_existent = str(Path(test_files["dir"]) / "nonexistent.txt")
    input_files = [str(test_files["file1"]), non_existent, str(test_files["file2"])]

    # Should not raise an exception
    concatenate_files(input_files, str(test_files["output"]))

    # Should still concatenate existing files
    output_content = test_files["output"].read_text()
    assert "File: file1.txt" in output_content
    assert "Content of file 1" in output_content
    assert "File: file2.txt" in output_content
    assert "Content of file 2" in output_content


def test_empty_file(test_files):
    """Test handling of empty files"""
    empty_file = Path(test_files["dir"]) / "empty.txt"
    empty_file.touch()

    input_files = [str(test_files["file1"]), str(empty_file)]
    concatenate_files(input_files, str(test_files["output"]))

    # Verify output
    output_content = test_files["output"].read_text()
    assert "File: file1.txt" in output_content
    assert "Content of file 1" in output_content
    assert "File: empty.txt" in output_content
    assert "--------------------" in output_content

    empty_file.unlink()


def test_file_name_display(test_files):
    """Test that file names are correctly displayed in the output"""
    input_files = [str(test_files["file1"])]
    concatenate_files(input_files, str(test_files["output"]))

    output_content = test_files["output"].read_text()

    # Check file name header format
    assert output_content.startswith("File: file1.txt\n\n")

    # Verify content follows the file name
    assert "Content of file 1" in output_content

    # Verify spacing between file name and content
    file_name_line, empty_line, *content = output_content.split("\n")
    assert file_name_line == "File: file1.txt"
    assert empty_line == ""

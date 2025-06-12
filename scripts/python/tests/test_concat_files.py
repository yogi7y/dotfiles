import unittest
import os
import tempfile
from pathlib import Path
import sys

# Add the parent directory to Python path so we can import our module
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from concat_files import concatenate_files


class TestConcatFiles(unittest.TestCase):
    def setUp(self):
        # Create a temporary directory for test files
        self.test_dir = tempfile.mkdtemp()

        # Create test input files
        self.file1_path = Path(self.test_dir) / "file1.txt"
        self.file2_path = Path(self.test_dir) / "file2.txt"
        self.output_path = Path(self.test_dir) / "output.txt"

        # Write test content
        self.file1_path.write_text("Content of file 1\nSecond line")
        self.file2_path.write_text("Content of file 2")

    def tearDown(self):
        # Clean up test files
        for file in [self.file1_path, self.file2_path, self.output_path]:
            if file.exists():
                file.unlink()
        os.rmdir(self.test_dir)

    def test_basic_concatenation(self):
        """Test basic file concatenation with two files"""
        input_files = [str(self.file1_path), str(self.file2_path)]
        concatenate_files(input_files, str(self.output_path))

        # Read the output and verify
        output_content = self.output_path.read_text()
        expected = "Content of file 1\nSecond line\n\n--------------------\n\nContent of file 2\n"
        self.assertEqual(output_content, expected)

    def test_missing_file(self):
        """Test handling of missing files"""
        non_existent = str(Path(self.test_dir) / "nonexistent.txt")
        input_files = [str(self.file1_path), non_existent, str(self.file2_path)]

        # Should not raise an exception
        concatenate_files(input_files, str(self.output_path))

        # Should still concatenate existing files
        output_content = self.output_path.read_text()
        self.assertIn("Content of file 1", output_content)
        self.assertIn("Content of file 2", output_content)

    def test_empty_file(self):
        """Test handling of empty files"""
        empty_file = Path(self.test_dir) / "empty.txt"
        empty_file.touch()

        input_files = [str(self.file1_path), str(empty_file)]
        concatenate_files(input_files, str(self.output_path))

        # Verify output
        output_content = self.output_path.read_text()
        self.assertIn("Content of file 1", output_content)
        self.assertIn("--------------------", output_content)

        empty_file.unlink()


if __name__ == "__main__":
    unittest.main()

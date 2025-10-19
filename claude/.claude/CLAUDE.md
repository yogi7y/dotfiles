# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) across all coding sessions.

## Tool-Specific Commands

### Flutter Development

- **ALWAYS use `fvm flutter` instead of `flutter`** - This ensures the correct Flutter SDK version for each project
- **ALWAYS use `fvm dart` instead of `dart`** - This ensures the correct Dart SDK version for each project
- **ALWAYS run `fvm flutter analyze` after making changes** - This checks for any errors or warnings in the code
- Examples:
  ```bash
  fvm flutter run          # NOT flutter run
  fvm flutter pub get      # NOT flutter pub get
  fvm flutter doctor       # NOT flutter doctor
  fvm dart analyze         # NOT dart analyze
  fvm flutter analyze      # Run after changes to check for errors
  ```

## Git

### Commit Messages

- **DO NOT include "Generated with Claude Code" or "Co-Authored-By: Claude" in commit messages** - Keep commit messages clean and professional without attribution footers

## GitHub

### GitHub CLI Usage

- **ALWAYS use `gh` CLI tool for GitHub-related content** - When the user shares GitHub links (PRs, issues, discussions, etc.), use the `gh` command to access the information instead of trying to fetch the URL directly

## Shell Navigation

### Directory Navigation

- **Use `z` (zoxide) for directory navigation** - `cd` is aliased to `z` in this environment
- Examples:
  ```bash
  z ~/projects            # Navigate to projects directory
  z projectname           # Jump to a frequently used directory
  ```

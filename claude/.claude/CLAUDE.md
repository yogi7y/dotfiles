# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) across all coding sessions.

## Coding Principles

- **Write clean, self-explanatory code** - Code should be readable without excessive comments
- **Follow DRY (Don't Repeat Yourself)** - Extract common logic into reusable functions/classes
- **Follow KISS (Keep It Simple, Stupid)** - Prefer simple solutions over complex ones
- **Follow YAGNI (You Aren't Gonna Need It)** - Only implement what is currently needed
- **Write unit tests for all new code** - Ensure code is testable and tested
- **Use meaningful names** - Variables, functions, and classes should clearly express their purpose

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

- **NEVER use functions that return widgets** - Always use StatelessWidget or StatefulWidget for better performance and debugging
  ```dart
  // ❌ BAD - Function returning widget
  Widget buildHeader(String title) {
    return Text(title);
  }

  // ✅ GOOD - StatelessWidget
  class Header extends StatelessWidget {
    const Header({required this.title, super.key});
    final String title;

    @override
    Widget build(BuildContext context) => Text(title);
  }
  ```

- **Use @immutable annotation** - All widgets and data classes should be immutable
- **Use const constructors wherever possible** - Improves performance by reusing widget instances

## Git

### Commit Messages

- **DO NOT include "Generated with Claude Code" or "Co-Authored-By: Claude" in commit messages** - Keep commit messages clean and professional without attribution footers

## GitHub

### GitHub CLI Usage

- **ALWAYS use `gh` CLI tool for GitHub-related content** - When the user shares GitHub links (PRs, issues, discussions, etc.), use the `gh` command to access the information instead of trying to fetch the URL directly

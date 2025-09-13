# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository containing configuration files for a macOS development environment. The repository uses GNU Stow for managing dotfiles symlinks and follows the XDG Base Directory specification for organizing configurations.

## Important Guidelines

### When Making Configuration Changes

1. **Always apply changes after editing**: After modifying any configuration file, ensure to:

   - Run `stow <package-name>` to update symlinks (e.g., `stow nvim` after editing nvim configs)
   - Source the configuration if it's for the current shell session (e.g., `source ~/.zshrc`)

2. **Respect XDG conventions**: All configurations should be placed in `.config` subdirectories within their respective package folders

3. **Preserve existing patterns**: Follow the existing structure and conventions used in each configuration file

### Stow Management

This repository uses GNU Stow for symlink management. Common commands:

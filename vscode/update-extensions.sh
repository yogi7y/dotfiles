#!/bin/bash
# Update the extensions list

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
code --list-extensions > "$SCRIPT_DIR/extensions.txt"
echo "Extensions list updated!"

#!/bin/bash
# Install VS Code extensions from extensions.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

if [ -f "$EXTENSIONS_FILE" ]; then
    echo "Installing VS Code extensions..."
    while IFS= read -r extension; do
        if [ -n "$extension" ]; then
            echo "Installing: $extension"
            code --install-extension "$extension"
        fi
    done < "$EXTENSIONS_FILE"
    echo "Extensions installation complete!"
else
    echo "Extensions file not found: $EXTENSIONS_FILE"
fi

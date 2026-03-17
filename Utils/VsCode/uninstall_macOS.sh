#!/bin/bash
# @doc
# @name: VS Code Uninstall (macOS)
# @description: Uninstall VS Code and remove all user data on macOS
# @category: Utilities
# @usage: bash Utils/VsCode/uninstall_macOS.sh
# @requirements: macOS
# @notes: Removes app, settings, extensions, and user data
# @/doc

set -euo pipefail

APP_PATH="/Applications/Visual Studio Code.app"
CONFIG_DIR="$HOME/Library/Application Support/Code"
VSCODE_DIR="$HOME/.vscode"

echo "=== Uninstalling VS Code ==="
echo ""

removed_something=false

# Remove application
if [ -d "$APP_PATH" ]; then
    echo "  Found VS Code at $APP_PATH"
    if [ -w "$APP_PATH" ]; then
        rm -rf "$APP_PATH"
    else
        sudo rm -rf "$APP_PATH"
    fi
    echo "  [OK] Application removed"
    removed_something=true
else
    echo "  VS Code not found at /Applications"
fi

# Remove settings and extensions
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo "  [OK] Settings and extensions removed"
    removed_something=true
fi

# Remove user data
if [ -d "$VSCODE_DIR" ]; then
    rm -rf "$VSCODE_DIR"
    echo "  [OK] User data (~/.vscode) removed"
    removed_something=true
fi

echo ""
if [ "$removed_something" = true ]; then
    echo "=== Uninstall complete! ==="
else
    echo "No changes made - VS Code not found."
fi

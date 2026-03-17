#!/bin/bash
# @doc
# @name: VS Code Settings (macOS)
# @description: Apply default VS Code settings
# @category: Core
# @usage: bash Core/VsCode/config/settings_macOS.sh
# @requirements: macOS, VS Code installed
# @notes: Copies default_settings_MacOS.json to the VS Code user settings location
# @/doc

set -euo pipefail

SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

echo "=== Applying VS Code Settings ==="
echo ""

mkdir -p "$SETTINGS_DIR"
curl -fsSL "$REPO_BASE_URL/Core/VsCode/config/default_settings_MacOS.json" > "$SETTINGS_FILE"
echo "  [OK] Settings applied to $SETTINGS_FILE"

echo ""
echo "=== VS Code settings complete! ==="

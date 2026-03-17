#!/bin/bash
# @doc
# @name: VS Code Extensions (macOS)
# @description: Install VS Code extensions from extensions.txt
# @category: Core
# @usage: bash Core/VsCode/config/extensions_macOS.sh
# @requirements: macOS, VS Code installed
# @notes: Reads extension IDs from extensions.txt (one per line, # comments and blank lines skipped)
# @/doc

set -euo pipefail

CODE_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"

echo "=== Installing VS Code Extensions ==="
echo ""

if [ ! -x "$CODE_CLI" ]; then
    echo "  ERROR: VS Code not found at $CODE_CLI"
    exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
    [[ -z "$line" || "$line" == \#* ]] && continue

    if "$CODE_CLI" --install-extension "$line" --force 2>/dev/null; then
        echo "  [OK] $line"
    else
        echo "  [FAIL] $line"
    fi
done < <(curl -fsSL "$REPO_BASE_URL/Core/VsCode/config/extensions.txt")

echo ""
echo "=== Extensions complete! ==="

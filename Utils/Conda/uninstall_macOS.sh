#!/bin/bash
# @doc
# @name: Conda/Miniforge Uninstall (macOS)
# @description: Uninstall Miniforge3/conda and remove all user data on macOS
# @category: Utilities
# @usage: bash Utils/Conda/uninstall_macOS.sh
# @requirements: macOS
# @notes: Removes conda installation, shell initialization, and config files
# @/doc

set -euo pipefail

echo "=== Uninstalling Miniforge3/Conda ==="
echo ""

removed_something=false

# Find conda base prefix
CONDA_BASE=""

# Try conda command first
if command -v conda &>/dev/null; then
    CONDA_BASE="$(conda info --base 2>/dev/null || true)"
fi

# Fallback: check common install locations
if [ -z "$CONDA_BASE" ] || [ ! -d "$CONDA_BASE" ]; then
    for candidate in "$HOME/miniforge3" "$HOME/miniconda3" "$HOME/anaconda3"; do
        if [ -d "$candidate" ]; then
            CONDA_BASE="$candidate"
            break
        fi
    done
fi

if [ -z "$CONDA_BASE" ]; then
    echo "  conda not found"
else
    echo "  Found conda at: $CONDA_BASE"

    # Safety check: refuse to delete home or root
    resolved_path="$(cd "$CONDA_BASE" && pwd)"
    if [ "$resolved_path" = "/" ] || [ "$resolved_path" = "$HOME" ]; then
        echo "  ERROR: Refusing to delete unsafe path: $resolved_path"
        exit 1
    fi

    # Undo shell initialization
    if command -v conda &>/dev/null; then
        conda init --reverse --all 2>/dev/null && \
            echo "  [OK] Shell initialization reversed" || \
            echo "  WARNING: Could not reverse conda init (may be okay)"
    fi

    # Remove conda installation
    if [ -d "$CONDA_BASE" ]; then
        if [ -w "$CONDA_BASE" ]; then
            rm -rf "$CONDA_BASE"
        else
            sudo rm -rf "$CONDA_BASE"
        fi
        echo "  [OK] Conda installation removed"
        removed_something=true
    fi
fi

# Remove user configuration
if [ -f "$HOME/.condarc" ]; then
    rm -f "$HOME/.condarc"
    echo "  [OK] Removed .condarc"
    removed_something=true
fi

if [ -d "$HOME/.conda" ]; then
    rm -rf "$HOME/.conda"
    echo "  [OK] Removed .conda"
    removed_something=true
fi

echo ""
if [ "$removed_something" = true ]; then
    echo "=== Uninstall complete! Restart your terminal. ==="
else
    echo "No changes made - conda not found."
fi

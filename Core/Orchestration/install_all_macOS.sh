#!/bin/bash
# @doc
# @name: Full Installation (macOS)
# @description: Orchestrate the full installation of Miniforge and VS Code on macOS
# @category: Core
# @usage: bash Core/Orchestration/install_all_macOS.sh
# @requirements: macOS, curl, unzip
# @notes: Runs all installation steps in order: Miniforge, VS Code (with extensions and settings)
# @/doc

set -euo pipefail

REPO_BASE_URL="${REPO_BASE_URL:-https://raw.githubusercontent.com/dtudk/pythonsupport-scripts/main}"
export REPO_BASE_URL

echo "========================================="
echo "  DTU Python Support - Full Installation"
echo "========================================="
echo ""

# Step 1: Install Miniforge/Conda
echo "--- Step 1/2: Miniforge ---"
bash <(curl -fsSL "$REPO_BASE_URL/Core/Conda/install/install_macOS.sh")
echo ""

# Step 2: Install VS Code (includes extensions and settings)
echo "--- Step 2/2: VS Code ---"
bash <(curl -fsSL "$REPO_BASE_URL/Core/VsCode/install/install_macOS.sh")
echo ""

echo "========================================="
echo "  Installation complete!"
echo "  Restart your terminal to activate conda."
echo "========================================="

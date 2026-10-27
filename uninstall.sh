#!/usr/bin/env bash
# =============================================================================
#  BlackIce Suite — Uninstaller / Revert Script
# =============================================================================

set -e

CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}=== BlackIce Uninstaller ===${RESET}\n"

read -p "Are you sure you want to revert BlackIce settings? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Aborted.${RESET}"
    exit 0
fi

# 1. Revert GNOME dconf settings to defaults
if command -v dconf >/dev/null 2>&1; then
    echo -e "${CYAN}[*] Resetting Dash to Dock and App Grid settings to default...${RESET}"
    dconf reset -f /org/gnome/shell/extensions/dash-to-dock/ || true
    dconf reset -f /org/gnome/shell/app-picker-layout || true
fi

# 2. Revert .zshrc additions
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${CYAN}[*] Removing BlackIce additions from ~/.zshrc...${RESET}"
    sed -i '/# BlackIce Suite/,$d' "$HOME/.zshrc" || true
fi

# 3. Disable extensions
if command -v gnome-extensions >/dev/null 2>&1; then
    echo -e "${CYAN}[*] Disabling BlackIce extensions...${RESET}"
    gnome-extensions disable "notchnux@adityasah.programs" 2>/dev/null || true
fi

echo -e "\n${GREEN}[✓] BlackIce configuration reverted. Log out and back in to reset full desktop state.${RESET}\n"


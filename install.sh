#!/usr/bin/env bash
# =============================================================================
#  ____  _            _    ___          
# | __ )| | __ _  ___| | _|_ _Hello___ ___ 
# |  _ \| |/ _` |/ __| |/ /| |/ __/ _ \
# | |_) | | (_| | (__|   < | | (_|  __/
# |____/|_|\__,_|\___|_|\_\___\___\___|
#
#  BlackIce — The Frosted Glass & Dynamic Island Desktop Suite for Kali Linux
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.blackice_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for terminal output
BOLD="\033[1m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
    ____  __            __   ____          
   / __ )/ /___ _____  / /__/  _/_______     
  / __  / / __ `/ __ \/ //_// // ___/ _ \    
 / /_/ / / /_/ / /_/ / ,< _/ // /__/  __/    
/_____/_/\__,_/\____/_/|_/___/\___/\___/     
EOF
echo -e "${RESET}${BOLD}The Frosted Glass & Dynamic Island Suite for Kali Linux${RESET}\n"

# -----------------------------------------------------------------------------
# 1. Environment & Pre-flight Checks
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Checking environment...${RESET}"
if [ -z "$DESKTOP_SESSION" ] && [ -z "$XDG_CURRENT_DESKTOP" ]; then
    echo -e "${YELLOW}[!] Warning: No graphical desktop session detected.${RESET}"
fi

# -----------------------------------------------------------------------------
# 2. Back Up Existing Configurations
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Creating backup of current configs at:${RESET} $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

[ -f "$HOME/.config/starship.toml" ] && cp "$HOME/.config/starship.toml" "$BACKUP_DIR/"
[ -d "$HOME/.config/fastfetch" ] && cp -r "$HOME/.config/fastfetch" "$BACKUP_DIR/"
[ -f "$HOME/.config/qterminal.org/qterminal.ini" ] && cp "$HOME/.config/qterminal.org/qterminal.ini" "$BACKUP_DIR/"
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/zshrc.bak"

# -----------------------------------------------------------------------------
# 3. Install Patched Typography (Nerd Font)
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Installing FiraCode Nerd Font (with Kali emblem & icon glyphs)...${RESET}"
mkdir -p "$HOME/.local/share/fonts/FiraCodeNerdFont"
cp -r "$SCRIPT_DIR/fonts/FiraCodeNerdFont/"* "$HOME/.local/share/fonts/FiraCodeNerdFont/"
fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1
echo -e "${GREEN}[✓] Fonts installed and cached.${RESET}"

# -----------------------------------------------------------------------------
# 4. Install GNOME Shell Themes & Dynamic Wallpapers
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Installing frosted glass themes and dynamic wallpapers...${RESET}"
mkdir -p "$HOME/.local/share/themes"
cp -r "$SCRIPT_DIR/themes/"* "$HOME/.local/share/themes/"

mkdir -p "$HOME/.local/share/backgrounds/dynamic-wallpapers"
cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.local/share/backgrounds/dynamic-wallpapers/"
echo -e "${GREEN}[✓] Themes and dynamic wallpapers installed.${RESET}"

# -----------------------------------------------------------------------------
# 5. Install & Configure GNOME Extensions
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Installing enhanced Dynamic Island (NotchNux) and Blur My Shell...${RESET}"
mkdir -p "$HOME/.local/share/gnome-shell/extensions"
cp -r "$SCRIPT_DIR/extensions/notchnux@adityasah.programs" "$HOME/.local/share/gnome-shell/extensions/"
cp -r "$SCRIPT_DIR/extensions/blur-my-shell@aunetx" "$HOME/.local/share/gnome-shell/extensions/"

# Enable extensions if gnome-extensions CLI is available
if command -v gnome-extensions >/dev/null 2>&1; then
    gnome-extensions enable "notchnux@adityasah.programs" 2>/dev/null || true
    gnome-extensions enable "blur-my-shell@aunetx" 2>/dev/null || true
    gnome-extensions enable "user-theme@gnome-shell-extensions.gcampax.github.com" 2>/dev/null || true
fi
echo -e "${GREEN}[✓] Extensions deployed.${RESET}"

# -----------------------------------------------------------------------------
# 6. Deploy Application & Toolchain Configurations
# -----------------------------------------------------------------------------
echo -e "${CYAN}[*] Deploying Starship, Fastfetch, and QTerminal configs...${RESET}"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/qterminal.org"
mkdir -p "$HOME/.config/notchnux"

cp "$SCRIPT_DIR/configs/starship/starship.toml" "$HOME/.config/starship.toml"
cp -r "$SCRIPT_DIR/configs/fastfetch/"* "$HOME/.config/fastfetch/"

# Substitute user's home directory into config templates
sed "s|__HOME__|$HOME|g" "$SCRIPT_DIR/configs/qterminal/qterminal.ini" > "$HOME/.config/qterminal.org/qterminal.ini"
sed "s|__HOME__|$HOME|g" "$SCRIPT_DIR/configs/notchnux/config.json" > "$HOME/.config/notchnux/config.json"

# Append BlackIce CLI suite to .zshrc if not already present
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "BlackIce Suite" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        cat "$SCRIPT_DIR/configs/zsh/zshrc_snippet.zsh" >> "$HOME/.zshrc"
        echo -e "${GREEN}[✓] Integrated BlackIce aliases and prompt into ~/.zshrc.${RESET}"
    fi
fi

# -----------------------------------------------------------------------------
# 7. Apply GNOME Desktop Layout (Dock, App Grid, Themes) via dconf
# -----------------------------------------------------------------------------
if command -v dconf >/dev/null 2>&1; then
    echo -e "${CYAN}[*] Applying macOS Glass dock, Launchpad grid, and themes...${RESET}"
    dconf load / < "$SCRIPT_DIR/dconf/blackice-gnome.dconf"
    echo -e "${GREEN}[✓] GNOME desktop settings loaded.${RESET}"
fi

# -----------------------------------------------------------------------------
# Done!
# -----------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}=================================================================${RESET}"
echo -e "${GREEN}${BOLD}  BlackIce Suite Installed Successfully!                       ${RESET}"
echo -e "${GREEN}${BOLD}=================================================================${RESET}"
echo -e "To complete the setup:"
echo -e " 1. Restart your terminal or run: ${CYAN}source ~/.zshrc${RESET}"
echo -e " 2. If the Dynamic Island or Blur does not appear immediately, log out and back in."
echo -e " 3. Backups saved at: ${YELLOW}$BACKUP_DIR${RESET}\n"

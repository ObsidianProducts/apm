#!/usr/bin/env bash
set -euo pipefail
# this has been recommented for those inspecting the script(s), for better implementations and modifications. (the previous comments were sloppy)
INSTALL_PATH="${APM_INSTALL_PATH:-/usr/local/bin/obsidian/aliases}"
ALIASES=("pkg" "apt" "dnf")

# color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# sudo things
path_requires_root() {
    local path="$1"
    local root_paths=("/usr" "/etc" "/opt" "/bin" "/sbin" "/lib")

    for root_path in "${root_paths[@]}"; do
        if [[ "$path" == "$root_path"* ]]; then
            return 0
        fi
    done
    return 1
}

check_and_request_root() {
    if path_requires_root "$INSTALL_PATH"; then
        if [[ $EUID -ne 0 ]]; then
            echo -e "${YELLOW}Warning:${RESET}  Uninstall path requires root access"
            echo "Requesting sudo..."
            exec sudo bash "$0" "$@"
        fi
    fi
}

check_and_request_root "$@"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BLUE}Aliased Package Managers${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "This will remove APM from: ${YELLOW}$INSTALL_PATH${RESET}"
echo -e "Symlinks to remove: ${YELLOW}${ALIASES[*]}${RESET}"
echo ""
echo -e "${YELLOW}Warning: This action cannot be undone.${RESET}"
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstall cancelled.${RESET}"
    exit 0
fi

# uninstallation stuff
echo ""
echo -e "${BLUE}→${RESET} Removing symlinks..."
for alias in "${ALIASES[@]}"; do
    target="/usr/local/bin/$alias"

    if [[ -L "$target" ]]; then
        rm "$target"
        echo -e "${GREEN}✓${RESET} Removed symlink: $target"
    elif [[ ! -e "$target" ]]; then
        echo -e "${YELLOW}Warning:${RESET}  Symlink not found: $target"
    else
        echo -e "${RED}✗${RESET} Not a symlink, skipping: $target" >&2
    fi
done

echo ""
echo -e "${BLUE}→${RESET} Removing script directory..."
if [[ -d "$INSTALL_PATH" ]]; then
    if rm -rf "$INSTALL_PATH"; then
        echo -e "${GREEN}✓${RESET} Removed: $INSTALL_PATH"
    else
        echo -e "${RED}✗${RESET} Failed to remove directory (you may need to do this manually)" >&2
    fi
else
    echo -e "${YELLOW}Warning:${RESET}  Directory not found: $INSTALL_PATH"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}Uninstallation complete!${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "If you added ${YELLOW}export APM_QUIET=1${RESET} to your shell config,"
echo -e "you can remove it now from ~/.bashrc, ~/.zshrc, etc."
echo ""

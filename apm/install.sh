#!/usr/bin/env bash
# this has been recommented for those inspecting the script(s), for better implementations and modifications. (the previous comments were sloppy)
set -euo pipefail

INSTALL_PATH="${APM_INSTALL_PATH:-/usr/local/bin/obsidian/aliases}"
SCRIPT_NAME="packagemanagers"
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
            echo -e "${YELLOW}Warning:${RESET}  Installation path requires root access"
            echo "Requesting sudo..."
            exec sudo bash "$0" "$@"
        fi
    fi
}

# friendly reminder to ensure "packagemanagers" is within the same directory as install.sh and your current terminal dir
if [[ ! -f "$SCRIPT_NAME" ]]; then
    echo -e "${RED}Error: '$SCRIPT_NAME' not found in current directory${RESET}" >&2
    echo "Make sure you're running this from the APM repository root." >&2
    exit 1
fi

check_and_request_root "$@"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BLUE}Aliased Package Managers${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "Install path: ${YELLOW}$INSTALL_PATH${RESET}"
echo -e "Aliases to create: ${YELLOW}${ALIASES[*]}${RESET}"
echo ""

# installation stuff
echo -e "${BLUE}→${RESET} Creating installation directory..."
mkdir -p "$INSTALL_PATH"
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✓${RESET} Directory created/verified"
else
    echo -e "${RED}✗${RESET} Failed to create directory" >&2
    exit 1
fi


echo -e "${BLUE}→${RESET} Installing script..."
cp "$SCRIPT_NAME" "$INSTALL_PATH/$SCRIPT_NAME"
if [[ $? -ne 0 ]]; then
    echo -e "${RED}✗${RESET} Failed to copy script" >&2
    exit 1
fi

chmod +x "$INSTALL_PATH/$SCRIPT_NAME"
echo -e "${GREEN}✓${RESET} Script installed and made executable"

echo -e "${BLUE}→${RESET} Creating symlinks..."
for alias in "${ALIASES[@]}"; do
    target="/usr/local/bin/$alias"

    if [[ -L "$target" ]]; then
        rm "$target"
        echo -e "${YELLOW}Warning:${RESET}  Replaced existing symlink: $target"
    elif [[ -e "$target" ]]; then
        echo -e "${RED}✗${RESET} File exists and is not a symlink: $target" >&2
        echo "   Skipping $alias" >&2
        continue
    fi

    ln -s "$INSTALL_PATH/$SCRIPT_NAME" "$target"
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✓${RESET} Created symlink: $target"
    else
        echo -e "${RED}✗${RESET} Failed to create symlink: $target" >&2
    fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}Installation complete!${RESET}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "Next steps:"
echo -e "  1. Test the installation: ${YELLOW}pkg --help${RESET}"
echo -e "  2. Try a command: ${YELLOW}pkg search vim${RESET}"
echo -e "  3. (Optional) Enable quiet mode: Add ${YELLOW}export APM_QUIET=1${RESET} to your shell config"
echo ""
echo -e "To uninstall, run: ${YELLOW}./uninstall.sh${RESET} within the same directory as your git clone path"
echo ""

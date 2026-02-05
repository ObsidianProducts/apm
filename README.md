# Aliased Package Managers (APM) 

A smart shell wrapper for Arch Linux package managers that acts as an alias layer, redirecting you to both `pacman` and `yay` when using these aliases.

## Notable features:
- **Smart Backend Detection** - Automatically uses `yay` if available, falls back to `pacman`.
- **Quiet Mode** - Suppress warnings for experienced users.
- **User Context Preservation** - Maintains proper user permissions when using AUR helpers.

## Installation

### Prerequisites

- Arch Linux or Arch-based distribution
- `bash` 4.0+ (or any other shell)
- `sudo` access

### Quick Install

Clone the repository and run the install script:

```bash
git clone https://github.com/ObsidianProductions/apm.git
cd apm
./install.sh
```

### Manual Installation

If you prefer manual setup:

```bash
# 1. Copy the script to your preferred location
sudo mkdir -p /usr/local/bin/obsidian/aliases
sudo cp packagemanagers /usr/local/bin/obsidian/aliases/packagemanagers
sudo chmod +x /usr/local/bin/obsidian/aliases/packagemanagers

# 2. Create symlinks for each package manager alias
sudo ln -sf /usr/local/bin/obsidian/aliases/packagemanagers /usr/local/bin/pkg
sudo ln -sf /usr/local/bin/obsidian/aliases/packagemanagers /usr/local/bin/apt
sudo ln -sf /usr/local/bin/obsidian/aliases/packagemanagers /usr/local/bin/dnf
```

### Custom Installation Path

To use a different installation path, set the `APM_INSTALL_PATH` environment variable before running the installer:

```bash
APM_INSTALL_PATH=/opt/apm sudo bash install.sh
```

This is useful for custom system setups or when `/usr/local/bin` isn't accessible. The variable is also read during uninstall, so set it the same way when removing:

```bash
APM_INSTALL_PATH=/opt/apm sudo bash uninstall.sh
```

Or manually:

```bash
sudo mkdir -p /your/custom/path/obsidian/aliases
sudo cp packagemanagers /your/custom/path/obsidian/aliases/packagemanagers
sudo chmod +x /your/custom/path/obsidian/aliases/packagemanagers
```

## Usage

### Basic Commands

```bash
# Install packages
sudo pkg install vim git

# Remove packages
sudo pkg remove vim

# Update system
sudo pkg update

# Search for packages
pkg search firefox

# Show package information
pkg info bash

# List installed packages
pkg list

# Clean package cache
sudo pkg clean

# Remove orphaned packages
sudo pkg autoremove
```

### Using Alternative Aliases

The same commands work with `apt` and `dnf` aliases:

```bash
sudo apt install vim
sudo dnf search firefox
```

### Available Commands

| Command | Description |
|---------|-------------|
| `install PACKAGE...` | Install one or more packages |
| `remove`, `uninstall PACKAGE...` | Remove packages and dependencies |
| `update`, `upgrade` | Update all installed packages |
| `search QUERY` | Search for packages |
| `info`, `show PACKAGE...` | Display package information |
| `list` | List all installed packages |
| `clean`, `cleanup` | Clear package cache |
| `autoremove` | Remove orphaned/unused packages |
| `help` | Show help message |
| `version` | Show version information |

## Quiet Mode

By default, APM shows a warning when you use non-native commands (like `pkg` instead of `pacman`). This is intentional, it helps new users learn the native commands.

To suppress these warnings permanently, add the following to your shell configuration:

**For Bash** (`~/.bashrc`):
```bash
export APM_QUIET=1
```

**For Zsh** (`~/.zshrc`):
```bash
export APM_QUIET=1
```

**For Fish** (`~/.config/fish/config.fish`):
```fish
set -gx APM_QUIET 1
```

After adding it, restart your shell or run `source ~/.bashrc` (or equivalent for your shell).

## Uninstallation

### Using Uninstall Script (in the git clone directory)

```bash
./uninstall.sh
```

### Manual Uninstallation

```bash
# Remove symlinks
sudo rm /usr/local/bin/pkg
sudo rm /usr/local/bin/apt
sudo rm /usr/local/bin/dnf

# Remove script directory (optional)
sudo rm -rf /usr/local/bin/obsidian/aliases/packagemanagers
```

## How It Works

APM acts as a transparent wrapper around `pacman` and `yay`:

1. **Command Detection** - Identifies which package manager alias you used
2. **Backend Selection** - Checks if `yay` is available; uses `pacman` as fallback
3. **Helping new users** - Warns non-native command usage and suggests native alternatives (unless quiet is enabled)

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `APM_QUIET` | `0` | Set to `1` to suppress warning messages |
| `APM_INSTALL_PATH` | `/usr/local/bin/obsidian/aliases` | Custom installation path |

## Distro Integration

APM is designed for easy integration into Arch-based distributions. Distro maintainers can:

1. **Package APM in repositories** - Include in official or community repositories for easy installation
2. **Set as default in shell configs** - Pre-enable in default shell profiles (e.g., `/etc/skel/.bashrc`)
3. **Customize installation paths** - Use `APM_INSTALL_PATH` during packaging to place files in distro-specific locations
4. **Enable quiet mode by default** - Set `APM_QUIET=1` in system-wide configs for experienced users
5. **Add shell completions** - Distribute bash/zsh/fish completion scripts (future feature)

## Future Plans

- [ ] Support for other Linux distributions (apt, dnf, zypper, etc.) (not current priority)
- [ ] Configuration file support (`~/.config/apm/config`)
- [ ] Interactive mode for new users
- [ ] Shell completion scripts (bash, zsh, fish)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

GNU General Public License v3.0 - See LICENSE file for details.

## Support

For issues, suggestions, or contributions, visit the [GitHub repository](https://github.com/ObsidianProducts/apm).

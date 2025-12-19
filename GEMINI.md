# Dotfiles Configuration

## Project Overview
This repository manages the configuration files (dotfiles) and installation scripts for setting up a consistent and powerful Linux development environment. It automates the installation of shell environments (Zsh), editors (Vim/Neovim), terminal multiplexers (Tmux), and a suite of modern CLI tools (Rust-based replacements for standard unix tools, Python utilities, etc.).

## Key Files and Directories

*   **`install.bash`**: The bootstrap script. It downloads necessary dependencies (`init.bash`, `functions.bash`) if missing and triggers the initialization process.
*   **`init.bash`**: The core setup script. It performs the heavy lifting:
    *   Installs system packages via `apt` or `yum`.
    *   Sets up a Python 3 virtual environment and installs pip packages.
    *   Installs/Configures `oh-my-zsh`, `tmux`, `git`, and `vim`.
    *   Installs Node.js (via `nvm`) and global npm packages.
    *   Installs Rust-based tools (`bat`, `eza`, `fd`, `ripgrep`, etc.).
    *   Symlinks configuration files from this directory to the user's home directory.
*   **`functions.bash`**: A library of helper functions used by `init.bash` and `update.bash` for tasks like checking commands, downloading GitHub releases, and managing versions.
*   **`syncdot.sh`**: The maintenance script. It updates system packages (`apt update`), pulls the latest dotfiles, updates submodules, and runs `update.bash`. It also handles syncing configurations to a backup location.
*   **`update.bash`**: A utility script to update specific modules or tools (e.g., `bash update.bash fzf node`).
*   **`zshrc`**: The Zsh configuration file.
*   **`vim/`**: Directory containing Vim configurations (`vimrc`) and installation scripts.
*   **`tmux.conf`**: Tmux configuration file.
*   **`fzf/`, `oh-my-zsh/`, `nvm/`**: Git submodules for external tools included in the setup.

## Installation

To bootstrap a new machine, execute the `install.bash` script. This is typically done via a curl-pipe-bash command (inferred from the script's content) or by cloning the repo and running:

```bash
./install.bash
```

This will:
1.  Verify/Download `functions.bash` and `init.bash`.
2.  Install system dependencies (requires `sudo`).
3.  Set up the full environment.

## Management & Updates

*   **Full Update:** Run `./syncdot.sh` to update the OS, dotfiles repo, submodules, and installed tools.
*   **Selective Update:** Run `./update.bash <module>` to update a specific tool.
    *   Example: `./update.bash fzf`
    *   Example: `./update.bash node` (installs/updates to LTS)
    *   Default (no args) updates a pre-defined list of core modules.

## Development Conventions

*   **Cross-Platform Support:** Scripts are designed to detect and support both Debian-based (`apt`) and RedHat-based (`yum`) distributions.
*   **Idempotency:** The setup scripts are generally written to be safe to re-run, checking for existing versions before installing.
*   **Symlinking:** Configuration files are symlinked (`ln -sfn`) rather than copied, allowing updates in the repo to be immediately reflected in the environment.
*   **Toolchain Management:**
    *   **Python:** Managed via a dedicated venv at `~/.local/lib/python3`.
    *   **Node:** Managed via `nvm`.
    *   **Rust/Go:** Tools are often downloaded directly from GitHub releases or installed via `cargo`/`go install`.

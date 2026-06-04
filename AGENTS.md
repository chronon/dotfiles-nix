# AGENTS.md

This file provides guidance to AI assistants when working with code in this repository.

## Overview

This is a personal dotfiles repository using Nix/Home Manager for configuration management across multiple hosts (macOS and Linux). The setup includes configurations for fish shell, neovim (LazyVim), git, Zed editor, Ghostty terminal, and WezTerm.

## Development Commands

### Build/Deploy Configuration

```bash
# Build and apply configuration changes
./build.sh

# Alternative: Direct home-manager switch
home-manager switch --flake .#$USER@$(hostname -s)
```

### Secret Management

The repository uses 1Password CLI for secret injection:

- Templates are in `fish/env.fish.tpl` and `github-copilot/hosts.json.tpl`
- Secrets are injected to `secrets/` directory during build
- Never commit files in `secrets/` directory

## Architecture

### Nix Flake Structure

- `flake.nix`: Main entry point defining host configurations. Hostnames matching
  `dev-*` are routed to the shared `hosts/dev` module; named hosts use their own dir.
- `home-manager/hosts/`: Host-specific configurations
  - `kanzi/`: ARM64 macOS host
  - `junaluska/`: x86_64 macOS host
  - `kaxair/`: x86_64 Linux host
  - `dev/`: Shared config for all `dev-*` hosts (headless aarch64-linux VMs)
- `home-manager/modules/`: Shared configuration modules
  - `base.nix`: Core packages and programs imported by every host
  - `workstation.nix`: GUI/full-workstation extras layered on `base` (macOS + kaxair)
  - `dev.nix`: Headless dev extras layered on `base` (gcc, rootless Docker host, bash→fish)
  - `macos.nix`: macOS-specific configurations
  - Individual tool configurations (fish, git, neovim, etc.)

### Scripts

- `build.sh`: Build and apply the home-manager config (run from repo root)
- `scripts/bootstrap.sh`: Enable Nix flakes + prepare secrets dir
- `scripts/dev-init.sh`: One-shot bootstrap for a fresh Linux dev host (Nix, repo clone, rootless Docker, build)
- `scripts/rootless-docker.sh`: Set up rootless Docker on a Debian/apt host

### Configuration Symlinks

Application configs are symlinked from dotfiles to XDG config directories:

- `nvim/` → `~/.config/nvim`
- `zed/` → `~/.config/zed`
- `wezterm/` → `~/.config/wezterm`

### Key Components

- **Shell**: Fish with pure prompt, fzf integration, and Catppuccin Mocha theme
- **Editor**: Neovim with LazyVim configuration
- **Git**: SSH signing enabled, difftastic for diffs, lazygit for TUI
- **Terminal**: Ghostty (primary), WezTerm (secondary)
- **Development**: Zed editor

## Tool-Specific Notes

### Neovim

- Based on LazyVim framework
- Configuration in `nvim/` directory
- Plugins managed through Lazy.nvim
- PHP development with Intelephense LSP

### Fish Shell

- Custom functions: `frg` (ripgrep + fzf), `set_paths`
- Abbreviations for Docker Compose and common tasks
- Catppuccin Mocha theme

### Git Configuration

- SSH signing with ed25519 key
- Difftastic for better diffs
- Sublime Merge integration for merging
- Custom aliases for common workflows

### Zed Editor

- Vim mode enabled
- Copilot for code completion
- JetBrains Mono Nerd Font
- PHP development setup with Intelephense

## Host-Specific Considerations

### macOS Hosts (kanzi, junaluska)

- 1Password CLI integration with agent socket
- Homebrew path additions
- Sublime Merge symlink for git mergetool
- Additional tools: cloudflared

### Linux Host (kaxair)

- Standard Linux paths and configurations
- Imports `base.nix` + `workstation.nix` for shared setup

### Dev Hosts (dev-*)

- Headless aarch64-linux VMs sharing the `hosts/dev` module
- Imports `base.nix` + `dev.nix` (no GUI/workstation extras)
- New dev box only needs a one-line arch entry in `flake.nix`'s `systems` — no new file

## Common Patterns

When modifying configurations:

1. Edit the appropriate module in `home-manager/modules/`
2. Run `./build.sh` to apply changes
3. Secrets are automatically injected during build
4. Application configs are symlinked, so changes are immediate

When adding new tools:

1. Add package to `home-manager/modules/base.nix` (all hosts), `workstation.nix`/`dev.nix` (layer-specific), or a host-specific file
2. Create dedicated module file if complex configuration needed
3. Add XDG symlink if external config directory exists


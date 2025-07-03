# README & CLAUDE

This file provides guidance to humans and Claude Code (claude.ai/code) when working with code in this repository.

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

- `flake.nix`: Main entry point defining host configurations
- `home-manager/hosts/`: Host-specific configurations
  - `kanzi/`: ARM64 macOS host
  - `junaluska/`: x86_64 macOS host
  - `nixair/`: x86_64 Linux host
- `home-manager/modules/`: Shared configuration modules
  - `common.nix`: Core packages and programs
  - `macos.nix`: macOS-specific configurations
  - Individual tool configurations (fish, git, neovim, etc.)

### Configuration Symlinks

Most application configs are symlinked from dotfiles to XDG config directories:

- `nvim/` → `~/.config/nvim`
- `zed/` → `~/.config/zed`
- `wezterm/` → `~/.config/wezterm`
- `ghostty/` → `~/.config/ghostty`

### Key Components

- **Shell**: Fish with pure prompt, fzf integration, and Catppuccin Mocha theme
- **Editor**: Neovim with LazyVim configuration
- **Git**: SSH signing enabled, difftastic for diffs, lazygit for TUI
- **Terminal**: Ghostty (primary), WezTerm (secondary)
- **Development**: Zed editor with Claude Sonnet 4 and Copilot integration

## Tool-Specific Notes

### Neovim

- Based on LazyVim framework
- Configuration in `nvim/` directory
- Plugins managed through Lazy.nvim
- PHP development with Intelephense LSP

### Fish Shell

- Custom functions: `frg` (ripgrep + fzf), `set_paths`, `set_colorscheme`
- Abbreviations for Docker Compose and common tasks
- Catppuccin Mocha color scheme

### Git Configuration

- SSH signing with ed25519 key
- Difftastic for better diffs
- Sublime Merge integration for merging
- Custom aliases for common workflows

### Zed Editor

- Vim mode enabled
- Claude Sonnet 4 for AI assistance
- Copilot for code completion
- JetBrains Mono Nerd Font
- PHP development setup with Intelephense

## Host-Specific Considerations

### macOS Hosts (kanzi, junaluska)

- 1Password CLI integration
- Homebrew path additions
- Sublime Merge symlink for git mergetool
- Additional tools: claude-code, cloudflared, gemini-cli, television

### Linux Host (nixair)

- Standard Linux paths and configurations
- Imports common.nix for shared setup

## Common Patterns

When modifying configurations:

1. Edit the appropriate module in `home-manager/modules/`
2. Run `./build.sh` to apply changes
3. Secrets are automatically injected during build
4. Application configs are symlinked, so changes are immediate

When adding new tools:

1. Add package to `home-manager/modules/common.nix` or host-specific file
2. Create dedicated module file if complex configuration needed
3. Add XDG symlink if external config directory exists


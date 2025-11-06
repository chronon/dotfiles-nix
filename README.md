# dotfiles

Personal configuration management using Nix and Home Manager across macOS and Linux hosts.

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Build and apply configuration
./build.sh
```

The build script will:
- Enable Nix experimental features if needed
- Inject secrets from 1Password CLI
- Apply home-manager configuration for your host

## Features

- **Unified theme**: Catppuccin Mocha across all tools
- **Shell**: Fish with pure prompt, fzf integration
- **Editor**: Neovim (LazyVim) with PHP/Intelephense support
- **Terminal**: Ghostty and WezTerm configurations
- **Development**: Zed editor with Claude Sonnet 4 and Copilot
- **Git**: SSH signing, difftastic diffs, lazygit integration
- **Secrets**: 1Password CLI for secure credential management

## Supported Hosts

- **kanzi**: ARM64 macOS (Apple Silicon)
- **junaluska**: x86_64 macOS (Intel)
- **kaxair**: x86_64 Linux

## Documentation

See **[CLAUDE.md](CLAUDE.md)** for detailed architecture and development guide.

## Requirements

- [Nix](https://nixos.org/download.html) with flakes enabled
- [1Password CLI](https://developer.1password.com/docs/cli) for secret management
- Git with SSH configured

## Manual Switch

```bash
home-manager switch --flake .#$USER@$(hostname -s)
```

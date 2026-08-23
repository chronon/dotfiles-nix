# dotfiles

Personal configuration management using Nix and Home Manager across macOS and Linux hosts.

## Quick Start

```bash
# Clone repository
git clone https://github.com/chronon/dotfiles-nix.git ~/dotfiles
cd ~/dotfiles

# Sets up Nix features and secrets
./scripts/bootstrap.sh

# Build and apply configuration
./build.sh
```

The build script will:
- Enable Nix experimental features if needed
- Inject secrets from 1Password CLI
- Apply home-manager configuration for your host

## Fresh Dev Host (Linux)

On a brand-new Linux machine, bootstrap everything (Nix, this repo, rootless
Docker, and the home-manager config) with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/chronon/dotfiles-nix/main/scripts/dev-init.sh | bash
```

Run it as your normal (non-root) user from a real login shell. It's safe to
re-run. To bootstrap from a branch instead of `main` (e.g. to test a PR), set
`DOTFILES_REF`:

```bash
curl -fsSL https://raw.githubusercontent.com/chronon/dotfiles-nix/main/scripts/dev-init.sh | DOTFILES_REF=my-branch bash
```

### Seeding from the Mac checkout

On an OrbStack guest the Mac checkout is visible over virtiofs, so `dev-init.sh`
seeds `~/dotfiles` from `/mnt/mac/Users/$USER/dotfiles` instead of cloning from
GitHub, and later re-runs fetch from there too. That needs no credentials and no
network — which also means the whole bootstrap works with a private repo, if you
run the script from the mount rather than piping it from `raw.githubusercontent`:

```bash
/mnt/mac/Users/$USER/dotfiles/scripts/dev-init.sh
```

Only committed state crosses the mount, so commit on the Mac before re-running.
`origin` still points at GitHub, so ordinary `git pull`/`push` work as usual.

GitHub is used automatically when the mount isn't there, or when `DOTFILES_REF`
names a branch that only exists on the remote. To skip the mount entirely, set
`MAC_DOTFILES` empty:

```bash
MAC_DOTFILES= ./scripts/dev-init.sh
```

### GitHub auth (dev VMs only)

There's no 1Password CLI on dev VMs, and `gh`'s config dir is a read-only
Nix symlink (so `gh auth login` can't write to it). Authenticate with a
fine-grained PAT via a fish universal variable instead:

```fish
set -Ux GH_TOKEN github_pat_xxxxx
gh auth status
```

`GH_TOKEN` is stored cleartext in `~/.config/fish/fish_variables`; fine for
a throwaway VM. For a per-session token that isn't persisted, use
`export GH_TOKEN=...` instead.

## Features

- **Unified theme**: Catppuccin Mocha across all tools
- **Shell**: Fish with pure prompt, fzf integration
- **Editor**: Neovim (LazyVim)
- **Terminal**: Ghostty configuration
- **Development**: Zed editor with Claude Sonnet 4 and Copilot
- **Git**: SSH signing, difftastic diffs, lazygit integration
- **Secrets**: 1Password CLI for secure credential management

## Supported Hosts

- **kanzi**: ARM64 macOS (Apple Silicon)
- **kaxair**: x86_64 Linux
- **dev-\***: Headless aarch64-linux dev VMs (shared config)

## Documentation

- **[CLAUDE.md](CLAUDE.md)**: Detailed architecture and development guide
- **[HOSTS.md](HOSTS.md)**: Host setup instructions for new macOS and Linux machines

## Requirements

- [Nix](https://nixos.org/download.html) with flakes enabled
- [1Password CLI](https://developer.1password.com/docs/cli) for secret management
- Git with SSH configured

## Manual Switch

```bash
home-manager switch --flake .#$USER@$(hostname -s)
```

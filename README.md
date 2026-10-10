# dotfiles

Personal configuration management using Nix and Home Manager across macOS and Linux hosts.

## Quick start

```bash
git clone https://github.com/chronon/dotfiles-nix.git ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap.sh   # enable Nix flakes, prepare secrets/
./build.sh               # inject secrets from 1Password, apply config for this host
```

To apply without secret injection: `home-manager switch --flake .#$USER@$(hostname -s)`

## Fresh dev host (Linux)

Bootstraps Nix, this repo, rootless Docker, and the home-manager config in one command. Run it as
your normal (non-root) user from a real login shell; it's safe to re-run.

```bash
curl -fsSL https://raw.githubusercontent.com/chronon/dotfiles-nix/main/scripts/dev-init.sh | bash
```

Set `DOTFILES_REF=my-branch` to clone a branch instead of `main`.

### Using the Mac checkout

On an OrbStack guest the Mac checkout is visible over virtiofs, so `dev-init.sh` makes `~/dotfiles`
a symlink to `/mnt/mac/Users/$USER/dotfiles` instead of cloning. The VM builds from and links into
the Mac's working tree, so edits there reach the VM without a commit or pull. That needs no
credentials and no network, so the whole bootstrap works with a private repo — run the script from
the mount rather than piping it from `raw.githubusercontent`:

```bash
/mnt/mac/Users/$USER/dotfiles/scripts/dev-init.sh
```

GitHub is used when the mount isn't there; `MAC_DOTFILES=` skips the mount entirely, which is also
how to use `DOTFILES_REF` on a VM that has the mount.

### GitHub auth (dev VMs)

There's no 1Password CLI on dev VMs, and `gh`'s config dir is a read-only Nix symlink, so
`gh auth login` can't write to it. Use a fine-grained PAT in a fish universal variable instead:

```fish
set -Ux GH_TOKEN github_pat_xxxxx
```

`GH_TOKEN` is stored cleartext in `~/.config/fish/fish_variables` — fine for a throwaway VM. For a
per-session token that isn't persisted, use `export GH_TOKEN=...`.

## Hosts

- **kanzi** — ARM64 macOS
- **kaxair** — x86_64 NixOS (MacBook Air); system config in `nixos/kaxair/`
- **dev-\*** — headless aarch64-linux dev VMs (shared config)

## Reference

- [AGENTS.md](AGENTS.md) — architecture and conventions
- [HOSTS.md](HOSTS.md) — setting up a new macOS or Linux machine

Requires Nix with flakes enabled, the 1Password CLI for secrets, and git with SSH configured.

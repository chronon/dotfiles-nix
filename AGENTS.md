# AGENTS.md

Guidance for AI assistants working in this repository. Personal dotfiles managed with Nix/Home
Manager across macOS and Linux hosts.

## Commands

```bash
./build.sh                                          # inject secrets, build, apply
home-manager switch --flake .#$USER@$(hostname -s)  # apply without secret injection
```

## Secrets

`build.sh` renders the `*.tpl` templates through the 1Password CLI into `secrets/` (the
template → output mapping lives in that script). Templates: `github-copilot/hosts.json.tpl`,
`git/allowed_signers.tpl`, `git/identity.conf.tpl`. **Never commit anything under `secrets/`.**

## Layout

- `flake.nix` — one `hosts` entry per machine (hostname → system); a single `username` binding sets
  `home.username` and names each config `username@hostname`. Hostnames matching `dev-*` route to the
  shared `hosts/dev` module, so a new dev box needs only that one line. Named hosts use their own
  `home-manager/hosts/<name>/` directory.
- `home-manager/modules/`
  - `base.nix` — imported by every host
  - `workstation.nix` — GUI extras layered on `base` (kanzi, kaxair)
  - `dev.nix` — headless extras layered on `base` (gcc, rootless Docker host, bash→fish, agent
    harnesses)
  - `macos.nix` — kanzi only: 1Password agent socket, Homebrew paths, Sublime Merge, orb shims
  - one module per tool (fish, git, neovim, …)
- `scripts/bootstrap.sh` — enable Nix flakes, prepare `secrets/`
- `scripts/dev-init.sh` — bootstrap a fresh Linux dev host end to end. Seeds `~/dotfiles` from the
  Mac checkout at `/mnt/mac/Users/$USER/dotfiles` when present (no network or credentials, so it
  works with a private repo), else clones from GitHub. Override with `MAC_DOTFILES`.
- `scripts/rootless-docker.sh` — rootless Docker on a Debian/apt host

## Symlinks

- `nvim/` → `~/.config/nvim`
- `zed/` → `~/.config/zed`
- `skills/` → `~/.claude/skills`, `~/.agents/skills`
- `agents/global.md` → `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.agents/AGENTS.md`

These are out-of-store symlinks, so edits take effect without a rebuild.

## Agent skills

`skills/<name>/SKILL.md` follows [Agent Skills](https://agentskills.io) and is symlinked into every
harness that reads the standard. Keep them portable: `name` and `description` are the only
frontmatter the standard requires, and `$ARGUMENTS` substitution is a Claude Code extension —
describe expected input in prose so a skill still works without it.

## Orb shims (macOS)

Agent harnesses are **not installed on macOS**. `orbTools` in `macos.nix` generates a fish function
per tool that runs it inside an OrbStack dev VM against the same working tree: `__orb_dir` maps
`$PWD` to its `/mnt/mac/...` path and checks the mount is virtiofs, `__orb_run` execs through
`orb bash -c` with the Nix profile on `PATH` and `direnv exec` when available, and `__orb_tool`
combines the two, falling back to the VM home with a warning when `$PWD` isn't mounted. `dvs` opens
a VM shell, or runs a single command, in the mapped directory.

Adding a tool to `orbTools` only creates the shim — install the tool itself via `dev.nix`.

## Adding a package

Add it to `base.nix` (all hosts), `workstation.nix`/`dev.nix` (per layer), or the host module. Give
it a dedicated module under `home-manager/modules/` if it needs real configuration, and add a
symlink above if it reads an external config directory.

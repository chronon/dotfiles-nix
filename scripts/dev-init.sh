#!/usr/bin/env bash

# Full dev environment bootstrap for a fresh Linux machine.
# Installs Nix, clones this dotfiles repo, sets up rootless Docker, and applies
# the home-manager configuration.
#
# Run as your normal (non-root) user from a real login shell, safe to re-run.

set -euo pipefail

readonly REPO_URL="https://github.com/chronon/dotfiles-nix.git"
readonly DOTFILES_DIR="$HOME/dotfiles"
# Branch/tag to check out; override to test a PR, e.g. DOTFILES_REF=my-branch
readonly DOTFILES_REF="${DOTFILES_REF:-main}"
readonly NIX_INSTALLER_URL="https://install.determinate.systems/nix"
readonly NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

# --- 1. Nix (Determinate) ----------------------------------------------------

if ! command -v nix >/dev/null 2>&1 && [[ ! -e "$NIX_PROFILE" ]]; then
  echo "Installing Determinate Nix..."
  curl -fsSL "$NIX_INSTALLER_URL" | sh -s -- install --no-confirm
else
  echo "Nix already installed"
fi

# The installer only wires up login shells, so source the profile to get nix
# onto PATH in this same run. (set +u: the profile touches unbound vars.)
if [[ -e "$NIX_PROFILE" ]]; then
  set +u
  # shellcheck disable=SC1090
  . "$NIX_PROFILE"
  set -u
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Error: nix not on PATH after install. Open a new shell and re-run." >&2
  exit 1
fi

# --- 2. git (needed for the clone) -------------------------------------------

if ! command -v git >/dev/null 2>&1; then
  echo "Installing git..."
  sudo apt-get update
  sudo apt-get install -y git
fi

# --- 3. Clone (or update) the dotfiles repo ----------------------------------

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "Updating existing $DOTFILES_DIR ($DOTFILES_REF)..."
  git -C "$DOTFILES_DIR" fetch origin
  git -C "$DOTFILES_DIR" checkout "$DOTFILES_REF"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  echo "Cloning $REPO_URL ($DOTFILES_REF) -> $DOTFILES_DIR..."
  git clone --branch "$DOTFILES_REF" "$REPO_URL" "$DOTFILES_DIR"
fi

# --- 4. Rootless Docker ------------------------------------------------------

echo "Setting up rootless Docker..."
"$DOTFILES_DIR/scripts/rootless-docker.sh"

# --- 5. OrbStack workaround: unreadable /proc/sys/kernel/modprobe ------------
# OrbStack's kernel returns EPERM reading this sysctl, which aborts Nix garbage
# collection (the GC root scan reads it and only tolerates ENOENT/EACCES).
# Bind-mount a plain file holding the standard value over it, via a systemd
# unit so the fix survives reboots. Skipped when the sysctl is readable.

if ! sudo cat /proc/sys/kernel/modprobe >/dev/null 2>&1; then
  echo "Installing /proc/sys/kernel/modprobe workaround for Nix GC..."
  echo -n /sbin/modprobe | sudo tee /etc/fake-modprobe >/dev/null
  sudo tee /etc/systemd/system/fix-modprobe-sysctl.service >/dev/null <<'EOF'
[Unit]
Description=Bind-mount readable file over /proc/sys/kernel/modprobe (OrbStack Nix GC fix)
DefaultDependencies=no
ConditionPathExists=/etc/fake-modprobe
After=systemd-sysctl.service
Before=nix-daemon.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/mount --bind /etc/fake-modprobe /proc/sys/kernel/modprobe

[Install]
WantedBy=sysinit.target
EOF
  sudo systemctl daemon-reload
  sudo systemctl enable --now fix-modprobe-sysctl.service
fi

# --- 6. Apply home-manager configuration -------------------------------------
# build.sh uses paths relative to the repo root and resolves the flake host as
# "$USER@$(hostname -s)", so the flake must define an entry for this machine.

echo "Building home-manager configuration..."
cd "$DOTFILES_DIR"
./build.sh

# --- 7. AI CLI tools (native installers) --------------------------------------
# Installed outside Nix so they can self-update; both land in ~/.local/bin,
# which fish already has on PATH. Put it on this shell's PATH too, so the
# installers skip writing PATH exports to ~/.bashrc (read-only, home-manager
# owns it).

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if ! command -v claude >/dev/null 2>&1 && [[ ! -x "$HOME/.local/bin/claude" ]]; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed"
fi

if ! command -v codex >/dev/null 2>&1 && [[ ! -x "$HOME/.local/bin/codex" ]]; then
  echo "Installing Codex..."
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
else
  echo "Codex already installed"
fi

echo
echo "Dev environment ready. Open a new shell to pick up Nix and the new config."

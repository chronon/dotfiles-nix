#!/usr/bin/env bash

# Full dev environment bootstrap for a fresh Linux machine.
# Installs Nix, links this dotfiles repo to the mounted Mac checkout (or clones
# it from GitHub when there's no mount), sets up rootless Docker, and applies
# the home-manager configuration.
#
# Run as your normal (non-root) user from a real login shell, safe to re-run.

set -euo pipefail

readonly REPO_URL="https://github.com/chronon/dotfiles-nix.git"
readonly DOTFILES_DIR="$HOME/dotfiles"
# Branch/tag for a GitHub clone; override to test a PR, e.g. DOTFILES_REF=my-branch
readonly DOTFILES_REF="${DOTFILES_REF:-main}"
readonly MAC_DOTFILES="${MAC_DOTFILES-/mnt/mac/Users/$USER/dotfiles}"
readonly NIX_INSTALLER_URL="https://install.determinate.systems/nix"
readonly NIX_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
readonly CODEX_CONFIG_SOURCE="$DOTFILES_DIR/codex/config.dev.toml"
readonly CODEX_CONFIG_TARGET="/etc/codex/config.toml"

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

# --- 3. Link (or clone) the dotfiles repo ------------------------------------
# When the Mac checkout is mounted, ~/dotfiles is a symlink to it, so the VM
# builds from and links into the Mac's working tree. Otherwise clone from GitHub.

if [[ -n "$MAC_DOTFILES" && -d "$MAC_DOTFILES/.git" ]]; then
  if [[ -L "$DOTFILES_DIR" && $(readlink "$DOTFILES_DIR") == "$MAC_DOTFILES" ]]; then
    echo "$DOTFILES_DIR already links to $MAC_DOTFILES"
  elif [[ -e "$DOTFILES_DIR" || -L "$DOTFILES_DIR" ]]; then
    echo "Error: $DOTFILES_DIR already exists; move it aside to link $MAC_DOTFILES there" >&2
    exit 1
  else
    echo "Linking $DOTFILES_DIR -> $MAC_DOTFILES..."
    ln -s "$MAC_DOTFILES" "$DOTFILES_DIR"
  fi
elif [[ -d "$DOTFILES_DIR/.git" ]]; then
  echo "Updating existing $DOTFILES_DIR ($DOTFILES_REF) from origin..."
  # A private repo with no credentials on the box fails here; that shouldn't
  # abort the run, since the checkout on disk is still usable.
  if git -C "$DOTFILES_DIR" fetch origin "$DOTFILES_REF"; then
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_REF"
    git -C "$DOTFILES_DIR" merge --ff-only FETCH_HEAD
  else
    echo "Warning: fetch from origin failed; using the checkout already on disk." >&2
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_REF"
  fi
else
  echo "Cloning $REPO_URL ($DOTFILES_REF) -> $DOTFILES_DIR..."
  git clone --branch "$DOTFILES_REF" "$REPO_URL" "$DOTFILES_DIR"
fi

# --- 4. Codex system configuration ------------------------------------------

echo "Installing Codex system configuration..."
sudo install -d -m 755 /etc/codex
if [[ -e "$CODEX_CONFIG_TARGET" || -L "$CODEX_CONFIG_TARGET" ]]; then
  if [[ -L "$CODEX_CONFIG_TARGET" && $(readlink "$CODEX_CONFIG_TARGET") == "$CODEX_CONFIG_SOURCE" ]]; then
    echo "Codex system configuration already installed"
  else
    echo "Error: $CODEX_CONFIG_TARGET already exists and is not managed by this script" >&2
    exit 1
  fi
else
  sudo ln -s "$CODEX_CONFIG_SOURCE" "$CODEX_CONFIG_TARGET"
fi

# --- 5. Rootless Docker ------------------------------------------------------

echo "Setting up rootless Docker..."
"$DOTFILES_DIR/scripts/rootless-docker.sh"

# --- 6. OrbStack workaround: unreadable /proc/sys/kernel/modprobe ------------
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

# --- 7. Apply home-manager configuration -------------------------------------
# build.sh uses paths relative to the repo root and resolves the flake host as
# "$USER@$(hostname -s)", so the flake must define an entry for this machine.

echo "Building home-manager configuration..."
cd "$DOTFILES_DIR"
./build.sh

echo
echo "Dev environment ready. Open a new shell to pick up Nix and the new config."

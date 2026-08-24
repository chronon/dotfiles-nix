#!/usr/bin/env bash

# Full dev environment bootstrap for a fresh Linux machine.
# Installs Nix, seeds this dotfiles repo (from the mounted Mac checkout when
# available, else GitHub), sets up rootless Docker, and applies the
# home-manager configuration.
#
# Run as your normal (non-root) user from a real login shell, safe to re-run.

set -euo pipefail

readonly REPO_URL="https://github.com/chronon/dotfiles-nix.git"
readonly DOTFILES_DIR="$HOME/dotfiles"
# Branch/tag to check out; override to test a PR, e.g. DOTFILES_REF=my-branch
readonly DOTFILES_REF="${DOTFILES_REF:-main}"
readonly MAC_DOTFILES="${MAC_DOTFILES-/mnt/mac/Users/$USER/dotfiles}"
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

# --- 3. Seed (or update) the dotfiles repo -----------------------------------
# Prefer the Mac checkout when it's mounted, falling back to GitHub. Only
# committed state crosses the mount, so commit on the Mac first to pick changes
# up here. origin stays pointed at GitHub either way.

# Is the host checkout mounted and usable as a git remote?
have_mount_repo() {
  [[ -n "$MAC_DOTFILES" && -d "$MAC_DOTFILES/.git" ]]
}

# Does the repo at $1 have $DOTFILES_REF? (A PR branch may exist only on the
# remote, in which case seeding can't work and we clone from GitHub instead.)
mount_has_ref() {
  git -C "$1" rev-parse --verify --quiet "refs/heads/$DOTFILES_REF" >/dev/null ||
    git -C "$1" rev-parse --verify --quiet "refs/tags/$DOTFILES_REF" >/dev/null
}

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  if have_mount_repo; then
    fetch_from="$MAC_DOTFILES"
  else
    fetch_from="origin"
  fi
  echo "Updating existing $DOTFILES_DIR ($DOTFILES_REF) from $fetch_from..."
  # A private repo with no credentials on the box fails here; that shouldn't
  # abort the run, since the checkout on disk is still usable.
  if git -C "$DOTFILES_DIR" fetch "$fetch_from" "$DOTFILES_REF"; then
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_REF"
    git -C "$DOTFILES_DIR" merge --ff-only FETCH_HEAD
  else
    echo "Warning: fetch from $fetch_from failed; using the checkout already on disk." >&2
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_REF"
  fi
elif have_mount_repo && mount_has_ref "$MAC_DOTFILES"; then
  echo "Seeding from host checkout $MAC_DOTFILES ($DOTFILES_REF) -> $DOTFILES_DIR..."
  # --no-hardlinks: keep the VM's object store independent of the Mac's, so it
  # survives the mount going away or a gc on the host.
  git clone --no-hardlinks --branch "$DOTFILES_REF" "$MAC_DOTFILES" "$DOTFILES_DIR"
  git -C "$DOTFILES_DIR" remote set-url origin "$REPO_URL"
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

echo
echo "Dev environment ready. Open a new shell to pick up Nix and the new config."

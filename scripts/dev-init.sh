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

# --- 5. Apply home-manager configuration -------------------------------------
# build.sh uses paths relative to the repo root and resolves the flake host as
# "$USER@$(hostname -s)", so the flake must define an entry for this machine.

echo "Building home-manager configuration..."
cd "$DOTFILES_DIR"
./build.sh

echo
echo "Dev environment ready. Open a new shell to pick up Nix and the new config."

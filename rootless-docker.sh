#!/usr/bin/env bash

# Set up rootless Docker on a Debian/apt-based machine or VM.
#
# Run as your normal (non-root) user from a proper login shell:
#   ./rootless-docker.sh
# Safe to re-run; each step is idempotent.

set -euo pipefail

readonly USERNAME="$(id -un)"
readonly UID_NUM="$(id -u)"
readonly SUBID_RANGE="${USERNAME}:100000:65536"
readonly DOCKER_SOCK="unix:///run/user/${UID_NUM}/docker.sock"
readonly BASHRC="$HOME/.bashrc"

# --- Sanity checks -----------------------------------------------------------

if [[ "$UID_NUM" -eq 0 ]]; then
  echo "Error: run as your normal user, not root (the script uses sudo where needed)" >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "Error: sudo is required" >&2
  exit 1
fi

if ! systemctl --user >/dev/null 2>&1; then
  echo "Error: your user systemd session isn't reachable (no \$XDG_RUNTIME_DIR/bus)." >&2
  echo "       Enter the machine with a real login shell (ssh, or 'orb shell -m <machine>' on OrbStack)." >&2
  exit 1
fi
echo "User systemd session OK (uid ${UID_NUM})"

# --- 1. Prerequisites + Docker binaries --------------------------------------

echo "Installing rootless prerequisites..."
sudo apt-get update
sudo apt-get install -y \
  uidmap dbus-user-session fuse-overlayfs slirp4netns curl ca-certificates

if ! command -v dockerd-rootless-setuptool.sh >/dev/null 2>&1; then
  echo "Installing Docker (official packages)..."
  curl -fsSL https://get.docker.com | sh
else
  echo "Docker already installed"
fi

# --- 2. Disable the rootful daemon -------------------------------------------
# get.docker.com installs and starts a system-wide (rootful) daemon. We want
# rootless instead, and its socket blocks the rootless installer, so shut it
# down and clear the stale socket. (On restricted hosts like isolated OrbStack
# machines the rootful daemon can't run containers anyway.)

echo "Disabling rootful Docker daemon..."
sudo systemctl disable --now docker.service docker.socket 2>/dev/null || true
sudo rm -f /var/run/docker.sock

# --- 3. subuid / subgid ranges -----------------------------------------------
# Needed for user namespaces. Append only if missing (idempotent).

for f in /etc/subuid /etc/subgid; do
  if ! sudo grep -q "^${USERNAME}:" "$f" 2>/dev/null; then
    echo "$SUBID_RANGE" | sudo tee -a "$f" >/dev/null
    echo "Added ${USERNAME} range to $f"
  else
    echo "${USERNAME} already present in $f"
  fi
done

# --- 4. Install + start the rootless daemon ----------------------------------

echo "Installing rootless Docker daemon..."
dockerd-rootless-setuptool.sh install

# Keep the daemon alive without an active login session.
sudo loginctl enable-linger "$USERNAME"
systemctl --user enable --now docker.service

# --- 5. Shell environment ----------------------------------------------------

add_bashrc_line() {
  local line="$1"
  if ! grep -qxF "$line" "$BASHRC" 2>/dev/null; then
    echo "$line" >>"$BASHRC"
    echo "Added to .bashrc: $line"
  fi
}
add_bashrc_line 'export PATH=/usr/bin:$PATH'
add_bashrc_line "export DOCKER_HOST=${DOCKER_SOCK}"

# --- 6. Verify ---------------------------------------------------------------

echo "Verifying with hello-world..."
export DOCKER_HOST="$DOCKER_SOCK"
docker run --rm hello-world

echo
echo "Rootless Docker is ready. Open a new shell (or 'source ~/.bashrc')"
echo "so DOCKER_HOST is set, then use docker normally."

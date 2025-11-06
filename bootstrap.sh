#!/usr/bin/env bash

set -euo pipefail

readonly NIX_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
readonly NIX_CONF="$NIX_CONF_DIR/nix.conf"
readonly NIX_FEATURES="experimental-features = nix-command flakes"
readonly SECRETS_DIR="secrets"

echo "Bootstrapping dotfiles environment..."

if ! command -v nix >/dev/null 2>&1; then
  echo "Error: Nix is not installed"
  exit 1
fi
echo "Nix installation verified"

mkdir -p "$NIX_CONF_DIR"
if ! grep -qF "$NIX_FEATURES" "$NIX_CONF" 2>/dev/null; then
  echo "$NIX_FEATURES" >>"$NIX_CONF"
  echo "Enabled Nix experimental features"
else
  echo "Nix experimental features already enabled"
fi

mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"
echo "Secrets directory ready"

if ! command -v op >/dev/null 2>&1; then
  echo "Warning: 1Password CLI not found - secret injection will be skipped"
else
  echo "1Password CLI verified"
fi

echo "Bootstrap complete. Run './build.sh' to apply configuration."

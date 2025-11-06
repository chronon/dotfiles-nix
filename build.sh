#!/usr/bin/env bash

set -euo pipefail

readonly HOSTNAME=$(hostname -s)
readonly SECRETS_DIR="secrets"
readonly TEMPLATE_FILES=(
  "github-copilot/hosts.json.tpl:secrets/github-copilot_hosts.json"
  "fish/env.fish.tpl:secrets/env.fish"
)

if command -v op >/dev/null 2>&1; then
  echo "Injecting secrets..."
  mkdir -p "$SECRETS_DIR"
  for pair in "${TEMPLATE_FILES[@]}"; do
    IFS=":" read -r template_file output_file <<<"$pair"
    op inject -f -i "$template_file" -o "$output_file" &
  done
  wait
else
  echo "Skipping secret injection (1Password CLI not found)"
fi

if command -v home-manager >/dev/null 2>&1; then
  HOME_MANAGER_CMD="home-manager"
else
  echo "Using nix run for home-manager (first build)"
  HOME_MANAGER_CMD="nix run home-manager --"
fi

$HOME_MANAGER_CMD switch --flake ".#$USER@$HOSTNAME"

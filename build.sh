#!/usr/bin/env bash

set -euo pipefail

readonly HOSTNAME=$(hostname -s)
readonly SECRETS_DIR="secrets"

# Check if this looks like a first run
if ! command -v op >/dev/null 2>&1; then
  echo "Warning: 1Password CLI (op) not found. Skipping secret injection."
  echo "After this build completes, run './build.sh' again to inject secrets."
  SKIP_SECRETS=true
else
  SKIP_SECRETS=false
fi

if [[ "$SKIP_SECRETS" == "false" ]]; then
  [[ ! -d "$SECRETS_DIR" ]] && mkdir -p "$SECRETS_DIR" && chmod 700 "$SECRETS_DIR"

  readonly TEMPLATE_FILES=(
    "github-copilot/hosts.json.tpl:secrets/github-copilot_hosts.json"
    "fish/env.fish.tpl:secrets/env.fish"
  )

  for pair in "${TEMPLATE_FILES[@]}"; do
    IFS=":" read -r template_file output_file <<<"$pair"
    op inject -f -i "$template_file" -o "$output_file" &
  done

  wait
fi

if command -v home-manager >/dev/null 2>&1; then
  HOME_MANAGER_CMD="home-manager"
else
  echo "First run: bootstrapping home-manager..."
  HOME_MANAGER_CMD="nix run home-manager --"
fi

$HOME_MANAGER_CMD switch --flake ".#$USER@$HOSTNAME"

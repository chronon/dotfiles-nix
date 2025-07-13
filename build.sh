#!/usr/bin/env bash

set -euo pipefail

readonly HOSTNAME=$(hostname -s)
readonly SECRETS_DIR="secrets"

command -v op >/dev/null 2>&1 || {
  echo "Error: 1Password CLI (op) is required but not installed." >&2
  exit 1
}

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

home-manager switch --flake ".#$USER@$HOSTNAME"

#!/usr/bin/env bash

set -euo pipefail

readonly HOSTNAME=$(hostname -s)
readonly SECRETS_DIR="secrets"
readonly TEMPLATE_FILES=(
  "github-copilot/hosts.json.tpl:secrets/github-copilot_hosts.json"
  "git/allowed_signers.tpl:secrets/git_allowed_signers"
  "git/identity.conf.tpl:secrets/git_identity.conf"
)

inject() {
  local template_file output_file
  IFS=":" read -r template_file output_file <<<"$1"
  op inject -f -i "$template_file" -o "$output_file"
}

if command -v op >/dev/null 2>&1; then
  echo "Injecting secrets..."
  mkdir -p "$SECRETS_DIR"
  inject "${TEMPLATE_FILES[0]}"
  for pair in "${TEMPLATE_FILES[@]:1}"; do
    inject "$pair" &
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

# -b backup: on a fresh machine, pre-existing dotfiles (.bashrc, .profile, ...)
# would otherwise block activation; back them up instead.
$HOME_MANAGER_CMD switch -b backup --flake ".#$USER@$HOSTNAME"

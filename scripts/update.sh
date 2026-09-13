#!/usr/bin/env bash

set -euo pipefail

ASSUME_YES=false
MESSAGE="Update lockfiles"

while (($#)); do
  case "$1" in
  -y | --yes) ASSUME_YES=true ;;
  -*)
    echo "Unknown option: $1" >&2
    exit 2
    ;;
  *) MESSAGE=$1 ;;
  esac
  shift
done

readonly ASSUME_YES MESSAGE
readonly REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly LOCKFILES=(flake.lock nvim/lazy-lock.json)
readonly GENERATED=(skills/herdr/SKILL.md)
readonly TRACKED=("${LOCKFILES[@]}" "${GENERATED[@]}")

confirm() {
  if [[ $ASSUME_YES == true ]]; then
    return 0
  fi

  if [[ ! -t 0 ]]; then
    echo "Not a terminal; pass -y to commit and push without confirmation" >&2
    return 1
  fi

  local reply
  read -r -p "Commit and push? [y/N] " reply || reply=""
  case "$reply" in
  y | Y | yes | YES) return 0 ;;
  *) return 1 ;;
  esac
}

cd "$REPO_ROOT"

echo "==> Updating flake inputs"
nix flake update

echo "==> Building and activating"
./build.sh

echo "==> Syncing neovim plugins"
nvim --headless "+Lazy! sync" +qa

echo "==> Regenerating herdr skill"
if command -v herdr >/dev/null; then
  tmp=$(mktemp)
  herdr --skill >"$tmp"
  install -m 644 "$tmp" skills/herdr/SKILL.md
  rm -f "$tmp"
else
  echo "herdr not installed on this host, leaving skills/herdr/SKILL.md unchanged"
fi

if git diff --quiet HEAD -- "${TRACKED[@]}"; then
  echo "No lockfile or generated file changes, nothing to commit"
  exit 0
fi

git --no-pager diff --stat HEAD -- "${TRACKED[@]}"

if ! confirm; then
  echo "Skipped; changes left in the working tree"
  exit 0
fi

git commit -m "$MESSAGE" -- "${TRACKED[@]}"
git push

if [[ -n $(git status --porcelain --untracked-files=no) ]]; then
  echo "Note: other changes left uncommitted in the working tree"
fi

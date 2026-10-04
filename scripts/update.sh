#!/usr/bin/env bash

set -euo pipefail

COMMIT=false
MESSAGE="Update lockfiles"

while (($#)); do
  case "$1" in
  -c | --commit) COMMIT=true ;;
  -*)
    echo "Unknown option: $1" >&2
    exit 2
    ;;
  *) MESSAGE=$1 ;;
  esac
  shift
done

readonly COMMIT MESSAGE
readonly REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly LOCKFILES=(flake.lock nvim/lazy-lock.json)

cd "$REPO_ROOT"

echo "==> Updating flake inputs"
nix flake update

echo "==> Building and activating"
./build.sh

echo "==> Syncing neovim plugins"
nvim --headless "+Lazy! sync" +qa

if git diff --quiet HEAD -- "${LOCKFILES[@]}"; then
  echo "No lockfile changes"
  exit 0
fi

git --no-pager diff --stat HEAD -- "${LOCKFILES[@]}"

if [[ $COMMIT != true ]]; then
  echo "Lockfile changes left uncommitted; pass -c to commit and push"
  exit 0
fi

git commit -m "$MESSAGE" -- "${LOCKFILES[@]}"
git push

if [[ -n $(git status --porcelain --untracked-files=no) ]]; then
  echo "Note: other changes left uncommitted in the working tree"
fi

#!/usr/bin/env bash

mkdir -p secrets

op inject -f -i github-copilot/hosts.json.tpl -o secrets/github-copilot_hosts.json
op inject -f -i fish/env.fish.tpl -o secrets/env.fish

home-manager switch --flake .#$USER@$(hostname -s)

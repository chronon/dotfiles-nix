# Host Setup Guide

## macOS

#### Install Homebrew Casks

```bash
brew update && brew install \
  1password \
  brave-browser \
  font-jetbrains-mono-nerd-font \
  ghostty \
  orbstack \
  sublime-merge \
  tableplus
```
## NixOS (kaxair)

The system config lives in `nixos/kaxair/` and is applied with `nixos-rebuild`; home-manager is
applied separately by `build.sh`.

1. **Install NixOS** with the graphical installer (KDE Plasma), user `chronon`, hostname `kaxair`.
   Install over Ethernet: the installer has no driver for the Broadcom Wi-Fi.

2. **Clone and build the system** from the console. A reinstall changes the disk UUIDs, so copy
   the regenerated `hardware-configuration.nix` into the repo and commit it:
   ```bash
   nix-shell -p git --run 'git clone https://github.com/chronon/dotfiles-nix.git ~/dotfiles'
   cp /etc/nixos/hardware-configuration.nix ~/dotfiles/nixos/kaxair/
   sudo nixos-rebuild boot --flake ~/dotfiles#kaxair && sudo reboot
   ```
   Then connect Wi-Fi with `nmcli device wifi connect "<SSID>" --ask`.

3. **Tailscale:** remove the old `kaxair` node in the admin console (otherwise the new one
   registers as `kaxair-1`), then run `sudo tailscale up`.

4. **1Password:** sign in to the desktop app, enable Settings → Developer → *Integrate with
   1Password CLI* and *Use the SSH agent*, then run `op signin`.

5. **Transfer secrets from an existing host** (NixOS has no rsync by default):
    ```bash
    scp -r secrets kaxair:dotfiles/
    ```

Then run Complete Setup from a terminal in the Plasma session, so `op` can unlock through the
desktop app.

## Complete Setup

```bash
./scripts/bootstrap.sh
./build.sh
```

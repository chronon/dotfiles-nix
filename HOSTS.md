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
## Arch Linux

1. **Install packages:**
   ```bash
   sudo pacman -S nix ghostty docker docker-compose docker-buildx
   paru 1password
   paru appimagelauncher
   paru brave-bin
   ```
   - Manually install [Sublime Merge](https://www.sublimemerge.com/docs/linux_repositories)
   - Manually download [TablePlus AppImage](https://tableplus.com/download/linux)

2. **Other setup:**
   ```bash
   # enable docker and add user to docker group
   sudo systemctl enable docker.service
   # log out for group changes to take effect
   sudo usermod -aG docker $USER
   # no password sudo
   echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER && sudo chmod 0440 /etc/sudoers.d/$USER
   # optionally change system shell to bash
   sudo usermod -s /usr/bin/bash $USER
   ```

3. **Transfer secrets to the new host from an existing host:**
    ```bash
    rsync -avz -L secrets [NEW_HOST]:dotfiles
    ```

## Complete Setup

```bash
./bootstrap.sh
./build.sh
```

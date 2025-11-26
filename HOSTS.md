# Host Setup Guide

## Setting Up a New macOS Host

### Install Homebrew Applications

Install the following applications using Homebrew:

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

### Complete Setup

After installing the required applications:

```bash
./bootstrap.sh  # Sets up Nix features and secrets directory
./build.sh      # Applies configuration
```

## Setting Up a New Linux Host

For Arch-based Linux distributions:

### On the New Host

1. **Install required packages:**
   ```bash
   sudo pacman -S nix ghostty docker docker-compose docker-buildx
   ```

2. **Install 1Password:**
   Follow the [official installation guide](https://support.1password.com/install-linux/#arch-linux) for Arch Linux.

3. **Configure Docker:**
   ```bash
   sudo systemctl enable docker.service
   sudo usermod -aG docker $USER
   ```
   Log out and back in for group changes to take effect.

### From Your Main Host

Transfer secrets to the new host:
```bash
rsync -avz -L secrets [NEW_HOST]:dotfiles
```

Replace `[NEW_HOST]` with the hostname or IP address of your new host.

### Complete Setup

On the new host, run:
```bash
./bootstrap.sh  # Sets up Nix features and secrets directory
./build.sh      # Applies configuration
```

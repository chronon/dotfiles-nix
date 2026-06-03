{ config, pkgs, ... }:

{

  imports = [
    ./fish.nix
    ./gh.nix
    ./git.nix
    ./neovim.nix
    ./sessionvars.nix
    ./ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "chronon";
    stateVersion = "23.11";
    file.".hushlogin".text = "";
    packages = with pkgs; [
      claude-code
      codex
      curl
      gnused
      go-task
      neovim
      nixfmt
      nodejs_24
      pnpm
      wget
      (pkgs.writeShellScriptBin "gsed" "exec ${pkgs.gnused}/bin/sed \"$@\"")
    ];
  };

  programs = {
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 100000;
    terminal = "tmux-256color";
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };

  xdg.enable = true;

  home.file = {
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude/settings.json";
    ".claude/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude/commands";
      recursive = true;
    };
  };

  catppuccin.flavor = "mocha";
  catppuccin.autoEnable = true;
  catppuccin.enable = true;

  # Tracking nixos-unstable + home-manager master, which report different
  # release strings; silence the mismatch warning.
  home.enableNixpkgsReleaseCheck = false;

}

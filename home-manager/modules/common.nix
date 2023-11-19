{ config, pkgs, ... }:

{

  imports = [
   ./fish.nix
   ./gh.nix
   ./git.nix
   ./neovim.nix
   ./ssh.nix
  ];

  home = {
    username = "chronon";
    stateVersion = "23.05";
    packages = with pkgs; [
      ansible
      bat
      curl
      fd
      gnused
      go-task
      nodejs_20
      nodejs_20.pkgs.pnpm
      pinentry
      wget
    ];
    file = { };
    sessionVariables = { };
  };

  programs = {
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  xdg = {
    enable = true;
    configFile = {
      "wezterm" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
        recursive = true;
      };
    };
  };

}
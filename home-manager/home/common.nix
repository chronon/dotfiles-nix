{ config, pkgs, ... }:

{

  imports = [
   ./fish.nix
   ./gh.nix
   ./git.nix
  ];

  home = {
    username = "chronon";
    stateVersion = "23.05";
    packages = with pkgs; [
      ansible
      bat
      curl
      fd
      gnupg
      gnused
      go-task
      jq
      nodejs_20
      nodejs_20.pkgs.pnpm
      pinentry
      ripgrep
      wget
    ];
    file = {
      "${config.home.homeDirectory}/intelephense" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/secrets/intelephense";
        recursive = true;
      };
    };
    sessionVariables = { };
  };

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    defaultEditor = true;
  };

  xdg = {
    enable = true;
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
        recursive = true;
      };
      "wezterm" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
        recursive = true;
      };
      "github-copilot/hosts.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/secrets/github-copilot_hosts.json";
      };
    };
  };

  programs.home-manager.enable = true;

}

{ config, pkgs, ... }:

{

  imports = [
   ./git.nix
  ];

  home = {
    username = "chronon";
    stateVersion = "23.05";
    packages = with pkgs; [
      ansible
      bat
      chezmoi
      curl
      # delta
      fd
      gh
      # git
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
    file = { };
    sessionVariables = { };
  };

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''source "$__fish_config_dir/config-real.fish"'';
    plugins = [
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
    ];
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
    };
  };

}

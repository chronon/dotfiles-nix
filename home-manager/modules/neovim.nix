{ config, pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    defaultEditor = true;
  };
  
  catppuccin.nvim.enable = false;

  home = {
    file = {
      "${config.home.homeDirectory}/intelephense" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/secrets/intelephense";
        recursive = true;
      };
    };
  };

  xdg = {
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
        recursive = true;
      };
      "snippets" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/snippets";
        recursive = true;
      };
      "github-copilot/hosts.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/secrets/github-copilot_hosts.json";
      };
    };
  };

}

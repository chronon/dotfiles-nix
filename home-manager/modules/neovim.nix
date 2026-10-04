{ config, dotfiles, ... }:

{

  home = {
    file = {
      "intelephense" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/secrets/intelephense";
      };
    };
  };

  xdg = {
    configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
      };
    };
  };

}

{ config, pkgs, ... }:

{

  programs.ssh = {
    enable = true;
    includes = ["conf.d/*"];
    forwardAgent = true;
  };

  home = {
    file = {
      "${config.home.homeDirectory}/.ssh/conf.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/secrets/ssh/conf.d";
        recursive = true;
      };
    };
  };
}

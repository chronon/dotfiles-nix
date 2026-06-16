{ config, pkgs, ... }:

{

  programs.ssh = {
    enable = true;
    includes = [ "conf.d/*" ];
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        StrictHostKeyChecking = "accept-new";
        HashKnownHosts = true;
      };
    };
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

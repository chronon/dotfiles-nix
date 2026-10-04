{ config, dotfiles, ... }:

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
      ".ssh/conf.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/secrets/ssh/conf.d";
      };
    };
  };
}

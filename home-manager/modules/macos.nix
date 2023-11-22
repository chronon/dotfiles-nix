{ config, pkgs, ... }:

{

  imports = [
   ./common.nix
  ];

  home = {
    homeDirectory = "/Users/${config.home.username}";
    packages = with pkgs; [
      pinentry_mac
      unixtools.watch
    ];

    file = {
      "${config.home.homeDirectory}/.1password/agent.sock" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };

}

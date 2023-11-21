{ config, pkgs, ... }:

{

  imports = [
   ../../modules/common.nix
  ];

  home = {
    homeDirectory = "/Users/${config.home.username}";
    packages = with pkgs; [
      pinentry_mac
      unixtools.watch
    ];
  };

}

{ config, pkgs, ... }:

{

  imports = [
   ../../modules/common.nix
  ];

  home = {
    homeDirectory = "/Users/chronon";
    packages = with pkgs; [
      pinentry_mac
      unixtools.watch
    ];
  };

}

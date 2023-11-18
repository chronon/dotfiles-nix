{ config, pkgs, ... }:

{

  imports = [
   ../../home/common.nix
  ];

  home = {
    homeDirectory = "/home/chronon";
    packages = with pkgs; [
      vim
    ];
  };

}

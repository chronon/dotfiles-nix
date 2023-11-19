{ config, pkgs, ... }:

{

  imports = [
   ../../modules/common.nix
  ];

  home = {
    homeDirectory = "/home/chronon";
    packages = with pkgs; [
      libcxxStdenv
      unzip
      wezterm
    ];
  };

}

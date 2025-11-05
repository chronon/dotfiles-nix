{ config, pkgs, ... }:

{

  imports = [
    ../../modules/common.nix
  ];

  home = {
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      libcxxStdenv
      unzip
    ];
  };

}

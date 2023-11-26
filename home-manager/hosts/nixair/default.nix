{ config, pkgs, ... }:

{

  imports = [
   ../../modules/common.nix
  ];

  home = {
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      _1password-gui 
      libcxxStdenv
      unzip
      wezterm
    ];
  };

}

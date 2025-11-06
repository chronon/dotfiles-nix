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
    sessionVariables = {
      OP_BIOMETRIC_UNLOCK_ENABLED = "true";
    };
  };

  programs.ghostty.settings = {
    font-size = 14;
    window-width = 100;
    window-height = 25;
  };

}

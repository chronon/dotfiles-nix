{ config, pkgs, ... }:

{

  imports = [
    ../../modules/base.nix
    ../../modules/workstation.nix
  ];

  home = {
    homeDirectory = "/home/${config.home.username}";
    packages = with pkgs; [
      libcxxStdenv
      sublime-merge
      unzip
    ];
    sessionVariables = {
      OP_BIOMETRIC_UNLOCK_ENABLED = "true";
    };
  };

  programs.fish.functions = {
    dvh.body = ''
      set -l machine $argv[1]
      test -n "$machine"; or set machine dev-main
      ssh -t kanzi /usr/local/bin/orb -m $machine fish -lc herdr
    '';
  };

  programs.ghostty.settings = {
    font-size = 12;
    window-width = 100;
    window-height = 25;
  };

}

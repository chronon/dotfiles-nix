{ pkgs, ... }:

{

  imports = [
    ../../modules/base.nix
    ../../modules/workstation.nix
  ];

  home = {
    packages = with pkgs; [
      gcc
      unzip
    ];
    sessionVariables = {
      OP_BIOMETRIC_UNLOCK_ENABLED = "true";
    };
  };

  programs.fish.shellAbbrs = {
    sysup = "sudo nixos-rebuild switch --flake $HOME/dotfiles#kaxair";
  };

  programs.fish.functions = {
    dvh.body = ''
      set -l machine $argv[1]
      test -n "$machine"; or set machine dev-main
      ssh -t kanzi /usr/local/bin/orb -m $machine fish -lc herdr
    '';
    sysgc.body = ''
      nix-env -p ~/.local/state/nix/profiles/home-manager --delete-generations +5
      and sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
      and sudo nix-collect-garbage
      and sudo /run/current-system/bin/switch-to-configuration boot
    '';
  };

  programs.ghostty.settings = {
    keybind = [ "shift+insert=paste_from_clipboard" ];
    font-size = 12;
    window-width = 100;
    window-height = 25;
  };

}

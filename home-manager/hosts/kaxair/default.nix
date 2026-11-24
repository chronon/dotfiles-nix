{
  config,
  pkgs,
  dotfiles,
  ...
}:

{

  imports = [
    ../../modules/base.nix
    ../../modules/workstation.nix
  ];

  home = {
    packages = with pkgs; [
      gcc
      unzip
      claude-code
    ];
    file.".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/settings.kaxair.json";
    file.".claude/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/keybindings.json";
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

{ config, pkgs, ... }:

{

  imports = [
    ./ghostty.nix
  ];

  home.packages = with pkgs; [
    _1password-cli
    ansible
    posting
    rclone
  ];

  programs.gpg.enable = true;

  programs.broot = {
    enable = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          key = "enter";
          shortcut = "e";
          execution = "$EDITOR +{line} {file}";
          apply_to = "text_file";
          leave_broot = false;
        }
      ];
    };
  };

  xdg.configFile = {
    "zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed";
      recursive = true;
    };
  };

}

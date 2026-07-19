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

  programs.fish.functions.coolify.body = ''
    command coolify --token (op read 'op://4pswfrz4cyx6mbnbbh5i2m3h4y/s5lw4576qr255iqxkmwxgtyrxa/add more/lpjtnsk3y3zvn5xfnaypaamihu') $argv
  '';

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

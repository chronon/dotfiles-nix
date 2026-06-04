{ config, pkgs, ... }:

# Full-workstation extras layered on top of base.nix: GUI apps plus CLI tools
# that the minimal headless hosts (e.g. the dev-true VM) don't need.

{

  imports = [
    ./ghostty.nix
  ];

  home.packages = with pkgs; [
    _1password-cli
    ansible
    curlie
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

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude/settings.json";

  xdg.configFile = {
    "wezterm" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
      recursive = true;
    };
    "zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed";
      recursive = true;
    };
  };

}

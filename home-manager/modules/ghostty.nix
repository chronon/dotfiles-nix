{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.ghostty = {
    enable = true;
    package = null;
    systemd.enable = false;

    settings = {
      theme = "Catppuccin Mocha";

      font-size = 16;
      command = "$HOME/.nix-profile/bin/fish --interactive";
      shell-integration-features = "no-cursor, ssh-env";
      cursor-style-blink = false;
      copy-on-select = "clipboard";

      split-divider-color = "#a6e3a1";

      keybind = [
        "ctrl+a>-=new_split:down"
        "ctrl+a>\\=new_split:right"
        "ctrl+shift+left=previous_tab"
        "ctrl+shift+right=next_tab"
        "shift+enter=text:\\n"
        "global:cmd+backquote=toggle_quick_terminal"
      ];

      mouse-scroll-multiplier = 0.3;
      macos-titlebar-style = "tabs";

      window-height = 75;
      window-width = 150;

      quick-terminal-position = "left";
      quick-terminal-size = "45%";
      quick-terminal-autohide = false;
      quick-terminal-animation-duration = 0;
    };
  };
}

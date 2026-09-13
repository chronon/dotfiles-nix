{ pkgs, ... }:

{

  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      theme = {
        name = "catppuccin";
        custom.sidebar_bg = "#181825";
      };
      terminal.default_shell = "${pkgs.fish}/bin/fish";
      keys = {
        prefix = "ctrl+a";
      };
      update.version_check = false;
    };
  };

}

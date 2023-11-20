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
      wezterm
    ];
  };

  xdg = {
    desktopEntries = {
      wezterm = {
        name = "WezTerm";
        exec = "wezterm";
        terminal = false;
        icon = "org.wezfurlong.wezterm";
        categories = [ "System" "TerminalEmulator" "Utility" ];
      };
    };
  };

}

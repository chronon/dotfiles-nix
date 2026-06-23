{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    gcc
    python3
    unzip
  ];

  programs.direnv = {
    enable = true;
    silent = true;
  };

  home.file.".terminfo/g/ghostty".source = "${pkgs.ghostty.terminfo}/share/terminfo/g/ghostty";
  home.file.".terminfo/x/xterm-ghostty".source =
    "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/claude/settings.dev.json";

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* && -z ''${INSIDE_FISH-} ]] && command -v fish >/dev/null; then
        export INSIDE_FISH=1
        exec fish
      fi
    '';
  };

  programs.fish.interactiveShellInit = ''
    set -gx DOCKER_HOST "unix:///run/user/"(id -u)"/docker.sock"
    set -g pure_color_hostname brred
    set -g pure_color_current_directory bryellow
  '';

}

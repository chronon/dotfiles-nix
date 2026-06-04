{ config, pkgs, ... }:

{

  home.packages = [ pkgs.gcc ];

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
  '';

}

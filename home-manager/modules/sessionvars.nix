{ config, pkgs, ... }:

{

  home = {
    sessionVariables = {
      BAT_THEME = "Coldark-Dark";
      EDITOR = "nvim";
      GPG_TTY = "(tty)";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      PAGER = "bat --style plain";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    };
    file = { };
  };

}

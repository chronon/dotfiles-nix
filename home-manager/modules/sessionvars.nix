{ config, pkgs, ... }:

{

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      GPG_TTY = "(tty)";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      PAGER = "bat --style plain";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
      PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    };
    file = { };
  };

}

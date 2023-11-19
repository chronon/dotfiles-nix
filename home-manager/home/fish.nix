{ config, pkgs, ... }:

{

  programs.fish = {
    enable = true;
    plugins = [
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
    ];
    shellAbbrs = {
      chrobill = "cd $HOME/machines/misc/chrobill && docker-compose up -d";
      dcdown = "docker compose down";
      dcex = "docker compose exec";
      dcup = "docker compose up -d";
      dcupl = "docker compose -f docker-compose.yml -f docker-compose.localdata.yml up -d";
      dudirs = "du -d 1 -h";
      kds = "find\ .\ -name\ .DS_Store\ -print\ -exec\ rm\ -f\ \{\}\ \\\;";
      mcore = "cd $HOME/machines/core/";
      ghprce = "git rebase --whitespace=fix origin/main && gh pr create --assignee @me --label enhancement";
      ghprcb = "git rebase --whitespace=fix origin/main && gh pr create --assignee @me --label bug";
    };
    interactiveShellInit = ''
      set_colorscheme
      set_env_vars
      set_paths

      bind \cg accept-autosuggestion execute

      if test -e "${config.home.homeDirectory}/dotfiles/secrets/fish_env.fish"
          . "${config.home.homeDirectory}/dotfiles/secrets/fish_env.fish"
      end

      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      end
    '';
    functions = {
      set_paths.body = ''
        fish_add_path "${config.home.homeDirectory}/bin"
        fish_add_path "${config.home.homeDirectory}/machines/core/bin"
        fish_add_path /usr/local/bin
        fish_add_path "${config.home.homeDirectory}/.local/bin"
      '';

      set_env_vars.body = ''
        set -Ux FZF_DEFAULT_COMMAND 'rg --files --hidden --glob \!.git'
        set -Ux BAT_THEME 'Visual Studio Dark+'
        set -Ux PAGER 'bat --style plain'
        set -Ux EDITOR nvim
        set -Ux GPG_TTY (tty)
        set -Ux MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -Ux MANROFFOPT -c
      '';

      set_colorscheme.body = ''
        set -l foreground DCD7BA normal
        set -l selection 2D4F67 brcyan
        set -l comment 727169 brblack
        set -l red C34043 red
        set -l orange FF9E64 brred
        set -l yellow C0A36E yellow
        set -l green 76946A green
        set -l purple 957FB8 magenta
        set -l cyan 7AA89F cyan
        set -l pink D27E99 brmagenta

        # Syntax Highlighting Colors
        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        # Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment

        # theme overrides
        set -U fish_pager_color_prefix green --bold
        set -U fish_color_valid_path white
      '';
    };
  };

}

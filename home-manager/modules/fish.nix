{ config, pkgs, ... }:

{

  xdg.configFile."fish/themes/Catppuccin Mocha.theme".source = "${pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
    sha256 = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
  }}/themes/Catppuccin Mocha.theme";

  programs.fish = {
    enable = true;
    plugins = [
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      {
        name = "catppuccin-fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
          sha256 = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
        };
      }
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
    };
    interactiveShellInit = ''
      set_paths

      bind \cg accept-autosuggestion execute

      fish_config theme choose "Catppuccin Mocha"
      set fish_color_valid_path

      if test -e "${config.home.homeDirectory}/dotfiles/secrets/op-cli.fish"
          . "${config.home.homeDirectory}/dotfiles/secrets/op-cli.fish"
      end

      if test -e "${config.home.homeDirectory}/dotfiles/secrets/env.fish"
          . "${config.home.homeDirectory}/dotfiles/secrets/env.fish"
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
        fish_add_path /opt/homebrew/bin
        fish_add_path "${config.home.homeDirectory}/.local/bin"
      '';

      frg.body = ''
        rg --smart-case --color=always --line-number --no-heading "$argv" |
          fzf --ansi \
            --color 'hl:-1:underline,hl+:-1:underline:reverse' \
            --delimiter ':' \
            --preview "bat --color=always {1} --theme='$BAT_THEME' --highlight-line {2}" \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
            --bind "enter:become($EDITOR +{2} {1})"
      '';
    };
  };

}

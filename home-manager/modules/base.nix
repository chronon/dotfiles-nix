{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";

  globalInstructions = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/agents/global.md";
  skills = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/skills";
in
{

  imports = [
    ./fish.nix
    ./gh.nix
    ./git.nix
    ./neovim.nix
    ./sessionvars.nix
    ./ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "23.11";
    file.".hushlogin".text = "";
    packages = with pkgs; [
      curl
      gnused
      go-task
      neovim
      nixfmt
      nodejs_24
      pnpm
      shellcheck
      wget
      (writeShellScriptBin "gsed" "exec ${gnused}/bin/sed \"$@\"")
    ];
  };

  programs = {
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    focusEvents = true;
    historyLimit = 100000;
    terminal = "tmux-256color";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
        '';
      }
    ];
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g set-clipboard on
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel

      # Catppuccin status line (sourced after the plugin so modules render)
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
    '';
  };

  xdg.enable = true;

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=1440
    minimum-release-age-strict=true
    block-exotic-subdeps=true
    verify-deps-before-run=warn
  '';

  home.file = {
    ".claude/CLAUDE.md".source = globalInstructions;
    ".codex/AGENTS.md".source = globalInstructions;
    ".agents/AGENTS.md".source = globalInstructions;
    ".claude/skills" = {
      source = skills;
      recursive = true;
    };
    ".agents/skills" = {
      source = skills;
      recursive = true;
    };
  };

  # Tracking nixos-unstable + home-manager master, which report different
  # release strings; silence the mismatch warning.
  home.enableNixpkgsReleaseCheck = false;

}

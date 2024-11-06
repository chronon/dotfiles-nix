{ config, pkgs, ... }:

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
    username = "chronon";
    stateVersion = "23.11";
    packages = with pkgs; [
      _1password-cli
      ansible
      curl
      gnused
      go-task
      nodejs_20
      nodejs_20.pkgs.pnpm
      rclone
      wget
      (pkgs.writeShellScriptBin "gsed" "exec ${pkgs.gnused}/bin/sed \"$@\"")
    ];
  };

  programs = {
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  programs.broot = {
    enable = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          key = "enter";
          shortcut = "e";
          execution = "$EDITOR +{line} {file}";
          apply_to = "text_file";
          leave_broot = false;
        }
      ];
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "wezterm" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
        recursive = true;
      };
    };
  };

}

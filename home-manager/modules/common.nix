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
      _1password
      ansible
      bat
      curl
      fd
      fzf
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
    direnv.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;
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

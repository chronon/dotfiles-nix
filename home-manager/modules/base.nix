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

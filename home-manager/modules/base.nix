{
  config,
  pkgs,
  dotfiles,
  ...
}:

let
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

  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: 1440
    minimumReleaseAgeStrict: true
    verifyDepsBeforeRun: warn
  '';

  home.file = {
    ".claude/CLAUDE.md".source = globalInstructions;
    ".codex/AGENTS.md".source = globalInstructions;
    ".agents/AGENTS.md".source = globalInstructions;
    ".claude/skills".source = skills;
    ".agents/skills".source = skills;
  };

  # Tracking nixos-unstable + home-manager master, which report different
  # release strings; silence the mismatch warning.
  home.enableNixpkgsReleaseCheck = false;

}

{ config, pkgs, ... }:

let
  primaryEmail = "gregory@chronon.com";
  secondaryEmail = "gregory@loadsys.com";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGWsRBSOvlCJsfypQvMprX65012c91pSs9Bu8TYEyAh";
in
{
  programs.git = {
    enable = true;
    userName = "Gregory Gaskill";
    userEmail = primaryEmail;
    signing = {
      key = sshKey;
      signByDefault = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
        quotePath = false;
      };
      credential.helper = "";
      init.defaultBranch = "main";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      pager.branch = false;
      pull.rebase = false;
      difftool.prompt = false;
      rerere.enabled = true;
      merge.tool = "smerge";
      mergetool.smerge = {
        cmd = "smerge mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
        trustExitCode = true;
      };
    };
    aliases = {
      st = "status -sb";
      mp = "!git checkout main && git pull --prune";
      wsfix = "!git rebase --whitespace=fix origin/main";
      cleanpush = "!git wsfix && git push origin \"$(git rev-parse --abbrev-ref HEAD)\"";
      find-merge = "!sh -c 'commit=$0 && branch=\${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'";
      show-merge = "!sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge'";
    };
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
    };
    ignores = [
      ".DS_Store"
      ".lazy.lua"
      ".parcel-cache"
      ".vim"
      ".vscode"
      ".zed"
      "node_modules"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      git.paging = {
        colorArg = "always";
        externalDiffCommand = "difft --color=always --display=inline";
      };
    };
  };

  xdg = {
    configFile = {
      "git/allowed_signers" = {
        text = ''${primaryEmail},${secondaryEmail} ${sshKey}'';
      };
    };
  };
}

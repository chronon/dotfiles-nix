{ config, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Gregory Gaskill";
    userEmail = "gregory@chronon.com";
    signing = {
      key = "715715478A5B85AF27DE43EC200609263BAC0D80";
      signByDefault = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
        quotePath = false;
      };
      init = {
        defaultBranch = "main";
      };
      pager = {
        branch = false;
      };
      pull = {
        rebase = false;
      };
      difftool = {
        prompt = false;
      };
      merge = {
        tool = "smerge";
      };
      mergetool.smerge = {
        cmd = "smerge mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
        trustExitCode = true;
      };
    };
    aliases = {
      st = "status -sb";
      mp = "! git checkout main && git pull --prune";
      prv = "! gh pr view --web";
      cleanpush = "! git rebase --whitespace=fix origin/main && git push origin \"$(git rev-parse --abbrev-ref HEAD)\"";
      find-merge = "! sh -c 'commit=$0 && branch=\${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'";
	    show-merge = "! sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge'";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
    ignores = [
      ".vscode"
      ".vim"
      ".DS_Store"
      ".parcel-cache"
      "node_modules"
    ];
  };

}

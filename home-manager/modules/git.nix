{ config, pkgs, ... }:

let
  # Committer emails live in 1Password and are rendered into
  # secrets/ at build time (see build.sh); they are symlinked in below
  # so real addresses stay out of this public repo.
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGWsRBSOvlCJsfypQvMprX65012c91pSs9Bu8TYEyAh";
in
{
  programs.git = {
    enable = true;
    signing = {
      key = sshKey;
      signByDefault = true;
      format = "ssh";
    };
    settings = {
      user = {
        name = "Gregory Gaskill";
      };
      # user.email is injected from 1Password into secrets/git_identity.conf.
      include.path = "${dotfiles}/secrets/git_identity.conf";
      core = {
        editor = "nvim";
        quotePath = false;
      };
      credential.helper = "";
      init.defaultBranch = "main";
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
      alias = {
        st = "status -sb";
        mp = "!git checkout main && git pull --prune";
        wsfix = "!git rebase --whitespace=fix origin/main";
        cleanpush = "!git wsfix && git push origin \"$(git rev-parse --abbrev-ref HEAD)\"";
        find-merge = "!sh -c 'commit=$0 && branch=\${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'";
        show-merge = "!sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge'";
      };
    };
    ignores = [
      ".lazy.lua"
      ".vscode"
      ".zed"
      "tmp_notes.md"
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
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/secrets/git_allowed_signers";
      };
    };
  };
}

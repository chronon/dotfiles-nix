{ config, pkgs, ... }:

{

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      version = 1;
      aliases = {
        prv = "pr view --web";
        prc = "pr checks";
        prce = "!git wsfix && gh pr create --assignee @me --label enhancement";
        prcb = "!git wsfix && gh pr create --assignee @me --label bug";
        prm = "!gh pr merge --merge --delete-branch && git mp";
      };
    };
  };

}

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
        prce = "pr create --assignee @me --label enhancement";
        prcb = "pr create --assignee @me --label bug";
        prcd = "pr create --assignee @me --label dependencies";
        prm = "!gh pr merge --merge --delete-branch && git mp";
        rlp = "run list -s in_progress";
      };
    };
  };

}

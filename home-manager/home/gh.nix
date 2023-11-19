{ config, pkgs, ... }:

{

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        prv = "pr view --web";
        prm = "pr merge --merge --delete-branch && git mp";
        prc = "pr checks";
      };
    };
  };

}

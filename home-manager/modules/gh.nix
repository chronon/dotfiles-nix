{ config, pkgs, ... }:

{

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        prv = "pr view --web";
        prc = "pr checks";
      };
    };
  };

}

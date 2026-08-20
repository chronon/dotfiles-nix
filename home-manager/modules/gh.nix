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
        botreview = ''
          !set -e
          pr=''${1:-$(gh pr view --json number -q .number)}
          [ -n "$pr" ] || exit 1

          gh api --paginate "repos/{owner}/{repo}/pulls/$pr/reviews" --jq '
            .[]
            | select(.user.type == "Bot")
            | select((.body // "") != "")
            | "[\(.user.login)] \(.state)\n\(.body)\n"
          '

          gh api --paginate "repos/{owner}/{repo}/pulls/$pr/comments" --jq '
            .[]
            | select(.user.type == "Bot")
            | "[\(.user.login)]\(if .position then "" else " (outdated)" end) \(.path):\(.line // .original_line)\n\(.body)\n"
          '
        '';
      };
    };
  };

}

{
  config,
  lib,
  cloudflare-skills,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";

  ownSkills = lib.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../../skills)
  );

  cloudflareSkills = [
    "agents-sdk"
    "cloudflare"
    "cloudflare-email-service"
    "durable-objects"
    "nextjs-on-cloudflare"
    "turnstile-spin"
    "web-perf"
    "workers-best-practices"
    "wrangler"
  ];

  sources =
    lib.genAttrs ownSkills (name: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/skills/${name}")
    // lib.genAttrs cloudflareSkills (name: "${cloudflare-skills}/skills/${name}");

  linksIn =
    dir: lib.mapAttrs' (name: source: lib.nameValuePair "${dir}/${name}" { inherit source; }) sources;
in
{

  home.file = {
    ".claude/skills".enable = false;
    ".agents/skills".enable = false;
  }
  // linksIn ".claude/skills"
  // linksIn ".agents/skills";

  # base.nix links these as whole directories; drop the old links so per-skill links don't land in the repo.
  home.activation.replaceSkillsDirLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for dir in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
      if [[ -L $dir ]]; then
        run rm "$dir"
      fi
    done
  '';

}

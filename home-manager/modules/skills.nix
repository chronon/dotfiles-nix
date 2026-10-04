{
  config,
  lib,
  cloudflare-skills,
  dotfiles,
  ...
}:

let
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
    // lib.genAttrs cloudflareSkills (name: "${cloudflare-skills}/skills/${name}")
    // {
      herdr = "${config.programs.herdr.package}/share/skills/herdr/herdr";
    };

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

}

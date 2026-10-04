{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      claude-code,
      codex,
      cloudflare-skills,
      ...
    }:
    let
      username = "chronon";

      hosts = {
        kanzi = "aarch64-darwin";
        kaxair = "x86_64-linux";
        dev-main = "aarch64-linux";
      };

      mkHomeConfiguration =
        hostname: system:
        let
          hostModule =
            if nixpkgs.lib.hasPrefix "dev-" hostname then
              ./home-manager/hosts/dev
            else
              ./home-manager/hosts/${hostname};
          homeDirectory =
            if nixpkgs.lib.hasSuffix "-darwin" system then "/Users/${username}" else "/home/${username}";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              claude-code.overlays.default
              codex.overlays.default
            ];
          };
          extraSpecialArgs = {
            inherit cloudflare-skills;
            dotfiles = "${homeDirectory}/dotfiles";
          };
          modules = [
            hostModule
            { home = { inherit username homeDirectory; }; }
          ];
        };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs' (
        hostname: system:
        nixpkgs.lib.nameValuePair "${username}@${hostname}" (mkHomeConfiguration hostname system)
      ) hosts;
    };
}

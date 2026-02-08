{
  description = "Home Manager configuration of chronon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.37";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex = {
      url = "github:sadjow/codex-cli-nix?ref=v0.98.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      catppuccin,
      home-manager,
      claude-code,
      codex,
      ...
    }:
    let
      username = "chronon";

      systems = {
        kanzi = "aarch64-darwin";
        junaluska = "x86_64-darwin";
        kaxair = "x86_64-linux";
      };

      mkHomeConfiguration =
        hostname: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              claude-code.overlays.default
              codex.overlays.default
            ];
          };
          modules = [
            catppuccin.homeModules.catppuccin
            ./home-manager/hosts/${hostname}
          ];
        };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs' (
        hostname: system:
        nixpkgs.lib.nameValuePair "${username}@${hostname}" (mkHomeConfiguration hostname system)
      ) systems;
    };
}

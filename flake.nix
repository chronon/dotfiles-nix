{
  description = "Home Manager configuration of chronon";

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
  };

  outputs =
    {
      nixpkgs,
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
        dev-true = "aarch64-linux";
      };

      mkHomeConfiguration =
        hostname: system:
        let
          hostModule =
            if nixpkgs.lib.hasPrefix "dev-" hostname then
              ./home-manager/hosts/dev
            else
              ./home-manager/hosts/${hostname};
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
          modules = [
            hostModule
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

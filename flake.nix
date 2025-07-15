{
  description = "Home Manager configuration of chronon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = "chronon";

      systems = {
        kanzi = "aarch64-darwin";
        junaluska = "x86_64-darwin";
        nixair = "x86_64-linux";
      };

      mkHomeConfiguration = hostname: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            ./home-manager/hosts/${hostname}
          ];
        };
    in {
      homeConfigurations = nixpkgs.lib.mapAttrs' (hostname: system:
        nixpkgs.lib.nameValuePair "${username}@${hostname}" (mkHomeConfiguration hostname system)
      ) systems;
    };
}

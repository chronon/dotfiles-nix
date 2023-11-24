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
      config = {
        # shared config
    };
    in {
      homeConfigurations = {
        "${username}@kanzi" = home-manager.lib.homeManagerConfiguration (config // {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            ./home-manager/hosts/kanzi
          ];
        });

        "${username}@junaluska" = home-manager.lib.homeManagerConfiguration (config // {
          pkgs = nixpkgs.legacyPackages."x86_64-darwin";
          modules = [
            ./home-manager/hosts/junaluska
          ];
        });

        "${username}@nixair" = home-manager.lib.homeManagerConfiguration (config // {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            ./home-manager/hosts/nixair
          ];
        });
      };
    };
}

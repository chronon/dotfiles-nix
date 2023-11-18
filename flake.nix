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

        "${username}@junaluska" = home-manager.lib.homeManagerConfiguration (config // {
          pkgs = nixpkgs.legacyPackages."x86_64-darwin";
          modules = [
            ./home-manager/hosts/junaluska
          ];
        });

        # "${username}@nixos" = home-manager.lib.homeManagerConfiguration (config // {
        #   pkgs = nixpkgs.legacyPackages."x86_64-linux";
        #   modules = [
        #     ./hosts/nixos
        #   ];
        # });
      };
    };
}

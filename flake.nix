{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      hosts = {
        kanzi = {
          system = "aarch64-darwin";
          user = "chronon";
        };
        junaluska = {
          system = "x86_64-darwin";
          user = "chronon";
        };
        kaxair = {
          system = "x86_64-linux";
          user = "chronon";
        };
        dev-true = {
          system = "aarch64-linux";
          user = "chronon";
        };
        dev-chronon = {
          system = "aarch64-linux";
          user = "chronon";
        };
        dev-main = {
          system = "aarch64-linux";
          user = "chronon";
        };
      };

      mkHomeConfiguration =
        hostname: host:
        let
          hostModule =
            if nixpkgs.lib.hasPrefix "dev-" hostname then
              ./home-manager/hosts/dev
            else
              ./home-manager/hosts/${hostname};
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit (host) system;
            config.allowUnfree = true;
          };
          modules = [
            hostModule
            { home.username = host.user; }
          ];
        };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs' (
        hostname: host:
        nixpkgs.lib.nameValuePair "${host.user}@${hostname}" (mkHomeConfiguration hostname host)
      ) hosts;
    };
}

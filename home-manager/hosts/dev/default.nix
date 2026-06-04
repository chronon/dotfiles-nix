{ config, ... }:

{

  imports = [
    ../../modules/base.nix
    ../../modules/dev.nix
  ];

  home = {
    homeDirectory = "/home/${config.home.username}";
  };

}

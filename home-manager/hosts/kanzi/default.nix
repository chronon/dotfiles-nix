{ config, pkgs, ... }:

{

  imports = [
    ../../modules/macos.nix
  ];

  # home.packages = with pkgs; [
  #   (llama-cpp.override { nodejs_latest = nodejs_24; })
  # ];

}

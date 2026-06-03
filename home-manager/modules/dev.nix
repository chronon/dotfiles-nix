{ ... }:

{

  programs.fish.interactiveShellInit = ''
    set -gx DOCKER_HOST "unix:///run/user/"(id -u)"/docker.sock"
  '';

}

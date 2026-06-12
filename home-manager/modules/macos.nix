{ config, pkgs, ... }:

{

  imports = [
    ./base.nix
    ./workstation.nix
  ];

  home = {
    homeDirectory = "/Users/${config.home.username}";
    packages = with pkgs; [
      cloudflared
      unixtools.watch
    ];

    file = {
      "${config.home.homeDirectory}/.1password/agent.sock" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
      "${config.home.homeDirectory}/bin/smerge" = {
        source = config.lib.file.mkOutOfStoreSymlink "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge";
      };
    };
  };

  programs.fish.functions = {
    __orb_dir.body = ''
      set -l vmdir "/mnt/mac"(pwd -P)
      set -l fstype (orb findmnt -no FSTYPE -T $vmdir 2>/dev/null)
      if test "$fstype" = virtiofs
          echo $vmdir
      else
          echo "orb: $PWD is not mounted in the VM" >&2
          return 1
      end
    '';

    __orb_run.body = ''
      orb bash -c 'export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH" DIRENV_LOG_FORMAT=; cd "$0" || exit 1; if command -v direnv >/dev/null; then exec direnv exec . "$@"; else exec "$@"; fi' $argv
    '';

    devshell.body = ''
      set -l vmdir (__orb_dir); or return 1
      __orb_run $vmdir fish
    '';
  };
}

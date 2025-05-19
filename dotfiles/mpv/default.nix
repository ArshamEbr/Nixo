{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/mpv/mpv.conf".text = ''
          keep-open=yes
        '';
      };
    };
    users.users.${user.name}.packages = with pkgs; [
      mpv
    ];
  }

{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/udiskie/config.yml".text = ''
        program_options:
          automount: true
          notify: true
          tray: auto
      '';
      };
    };
    environment.systemPackages = with pkgs-unstable; [
      udiskie
    ];
  }
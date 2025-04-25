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
    users.users.${user.name}.packages = with pkgs-unstable; [
      udiskie
    ];
  }
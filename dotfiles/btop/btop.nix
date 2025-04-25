{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/btop/btop.conf".text = ''
        color_theme = "Default"
        rounded_corners = True
        theme_background = False
        update_ms = 100
      '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
      btop
    ];
  }

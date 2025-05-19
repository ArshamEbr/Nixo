{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/winapps/winapps.conf".text = ''
          RDP_USER="${user.name}"
          RDP_PASS="1"
          RDP_IP="127.0.0.1"
          RDP_SCALE=100
          RDP_DOMAIN=""
          FREERDP_COMMAND="wlfreerdp"
          RDP_FLAGS="/cert:ignore"
        '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
    ];
  }

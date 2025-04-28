{ pkgs, config, lib, user, pkgs-unstable, ... }:{

#  dotfiles = {
#      username = "${user.name}";
#      files = {
#        ".config/bspwm/bspwmrc".text = ''
#        '';
#      };
#    };
    services = {
        displayManager = {
        #  sddm = {
        #    enable = true;
        #    wayland.enable = true;
        #  };
        };

      xserver = {
        enable = true;

      #  windowManager.bspwm = {
      #    enable = true;
      #    package = pkgs-unstable.bspwm;
      #    sxhkd = {
      #      package = pkgs-unstable.sxhkd;
      #    };
      #  };

        xkb = {
          layout = "us";
          variant = "";
        };
      };
    };
  }
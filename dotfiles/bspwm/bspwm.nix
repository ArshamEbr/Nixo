{ pkgs, config, lib, user, pkgs-unstable, ... }:{

#  dotfiles = {
#      username = "${user.name}";
#      files = {
#        ".config/bspwm/bspwmrc".text = ''
#        '';
#      };
#    };
    services.xserver.windowManager.bspwm = {
      enable = true;
      package = pkgs-unstable.bspwm;
      sxhkd.package = pkgs-unstable.sxhkd;
    };
  }

{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.btop = {
      enable = true;
      package = pkgs-unstable.btop;
      settings = {
        theme_background = false;
      #  color_theme = "Default";
        rounded_corners = true;
        update_ms = 100;
      };
    };
  }
{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    wayland.windowManager.hyprland.settings = {
      
      general = {
        "col.active_border" = "rgba(111111ff) rgba(00ffffff) rgba(222222ff) rgba(ff00ffff) rgba(333333ff) rgba(ffffffff) 60deg";
      #  "col.active_border" = "rgba(F7DCDE39)";
        "col.inactive_border" = "rgba(ffffffff) rgba(00000000) rgba(00000000) rgba(00000000) rgba(00000000) rgba(00000000) rgba(00000000) rgba(00000000) rgba(00000000) rgba(ffffffff) 60deg";
      };
    
      misc = {
        background_color = "rgba(1D1011FF)";
      };
    
      plugin = {
        hyprbars = {
          bar_text_font = "Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif";
          bar_height = 30;
          bar_padding = 10;
          bar_button_padding = 5;
          bar_precedence_over_border = true;
          bar_part_of_window = true;
    
          bar_color = "rgba(1D1011FF)";
          "col.text" = "rgba(F7DCDEFF)";
    
          # Buttons as a list of strings
          hyprbars-button = [
            "rgb(F7DCDE), 13, 󰖭, hyprctl dispatch killactive"
            "rgb(F7DCDE), 13, 󰖯, hyprctl dispatch fullscreen 1"
            "rgb(F7DCDE), 13, 󰖰, hyprctl dispatch movetoworkspacesilent special"
          ];
        };
      };
    };
  }
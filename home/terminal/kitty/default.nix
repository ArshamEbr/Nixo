{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.kitty = {
      enable = true;
      package = pkgs-unstable.kitty;
      shellIntegration.enableFishIntegration = true;
      enableGitIntegration = true;
      settings = {
        # Cursor
        cursor_shape = "beam";
    
        # Appearance
        background_opacity = "0.7";
        background = "#0F131C";
        window_margin_width = "21.75";
    
        # No confirmation on close
        confirm_os_window_close = "0";
    
        # Shell
        shell = "fish";
      };

      font = {
        name = "SpaceMono Nerd Font";
        size = "11.0";
      };

      keybindings = {
        # Basic copy-paste
        "ctrl+c" = "copy_or_interrupt";
    
        # Zoom in
        "ctrl+plus" = "change_font_size all +1";
        "ctrl+equal" = "change_font_size all +1";
        "ctrl+kp_add" = "change_font_size all +1";
    
        # Zoom out
        "ctrl+minus" = "change_font_size all -1";
        "ctrl+underscore" = "change_font_size all -1";
        "ctrl+kp_subtract" = "change_font_size all -1";
    
        # Reset zoom
        "ctrl+0" = "change_font_size all 0";
        "ctrl+kp_0" = "change_font_size all 0";
      };
    };
  }
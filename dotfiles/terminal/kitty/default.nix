{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/kitty/kitty.conf".text = ''
          # Font
          font_family      SpaceMono Nerd Font
          font_size 11.0
          
          # Cursor shape
          cursor_shape beam
          
          window_margin_width 21.75
          
          background_opacity 0.7
          background #0F131C
          
          # No stupid close confirmation
          confirm_os_window_close 0
          
          # Use fish shell
          shell fish
          
          # Copy for normies
          map ctrl+c       copy_or_interrupt
          
          # Zoom
          map ctrl+plus  change_font_size all +1
          map ctrl+equal  change_font_size all +1
          map ctrl+kp_add  change_font_size all +1
          
          map ctrl+minus       change_font_size all -1
          map ctrl+underscore       change_font_size all -1
          map ctrl+kp_subtract       change_font_size all -1
          
          map ctrl+0 change_font_size all 0
          map ctrl+kp_0 change_font_size all 0
        '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
      kitty
    ];
  }

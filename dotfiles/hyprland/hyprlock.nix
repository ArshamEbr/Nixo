{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/hyprlock.conf".text = ''
        $entry_background_color=rgba(18111A11)
        $entry_border_color=rgba(9A8C9C55)
        $entry_color=rgba(D1C2D2FF)
        $font_family=Audiowide
        $font_family_clock=Saira Stencil One
        $font_material_symbols=Material Symbols Rounded
        $text_color=rgba(ECDEECFF)
        background {
          blur_passes=4
          blur_size=5
          color=rgba(130C15FF)
          color=rgba(000000FF)
          path=$HOME/nixo/resources/wallpapers/wolf.jpg
        }
        
        input-field {
          monitor=
          size=250, 50
          dots_size=0.1
          dots_spacing=0.3
          font_color=$entry_color
          halign=center
          inner_color=$entry_background_color
          outer_color=$entry_border_color
          outline_thickness=2
          position=0, 20
          valign=center
        }
        
        label {
          monitor=
          color=$text_color
          font_family=$font_family_clock
          font_size=120
          halign=center
          position=0, 300
          shadow_boost=0.5
          shadow_passes=1
          text=$TIME
          valign=center
        }
        
        label {
          monitor=
          color=$text_color
          font_family=$font_family
          font_size=20
          halign=center
          position=0, 200
          shadow_boost=0.5
          shadow_passes=1
          text=hi $USER !!!
          valign=center
        }
        
        label {
          monitor=
          color=$text_color
          font_family=$font_material_symbols
          font_size=21
          halign=center
          position=0, 65
          shadow_boost=0.5
          shadow_passes=1
          text=lock
          valign=bottom
        }
        
        label {
          monitor=
          color=$text_color
          font_family=$font_family
          font_size=14
          halign=center
          position=0, 45
          shadow_boost=0.5
          shadow_passes=1
          text=locked
          valign=bottom
        }
        
        label {
          monitor=
          color=$text_color
          font_family=$font_family
          font_size=14
          halign=left
          position=30, -30
          shadow_boost=0.5
          shadow_passes=1
          text=cmd[update:5000] battery_percent
          valign=top
        }
      '';
      };
    };

    programs.hyprlock = {
      enable = true;
      package = pkgs.hyprlock;
    };
  }

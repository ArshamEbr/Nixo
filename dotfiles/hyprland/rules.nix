{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/rules.conf".text = ''
        ######### Window rules ########
      #  windowrule = noblur,.*
      #  windowrule = opacity 0.89 override 0.89 override, .* # Applies transparency to EVERY WINDOW
      #  windowrule = float, ^(blueberry.py)$
      #  windowrule = float, ^(steam)$
      #  windowrule = float, ^(guifetch)$ # FlafyDev/guifetch

        windowrule = center, title:^(Open File)(.*)$
        windowrule = center, title:^(Select a File)(.*)$
        windowrule = center, title:^(Choose wallpaper)(.*)$
        windowrule = center, title:^(Open Folder)(.*)$
        windowrule = center, title:^(Save As)(.*)$
        windowrule = center, title:^(Library)(.*)$
        windowrule = center, title:^(File Upload)(.*)$

        # Dialogs
        windowrule = float,title:^(Open File)(.*)$
        windowrule = float,title:^(Select a File)(.*)$
        windowrule = float,title:^(Choose wallpaper)(.*)$
        windowrule = float,title:^(Open Folder)(.*)$
        windowrule = float,title:^(Save As)(.*)$
        windowrule = float,title:^(Library)(.*)$
        windowrule = float,title:^(File Upload)(.*)$

        # Tearing
      #  windowrule = immediate,.*.exe

        ######### Window rules v2 #########
        windowrulev2 = bordercolor rgba(ECB2FFAA) rgba(ECB2FF77),pinned:1
        windowrulev2 = tile, class:(dev.warp.Warp)
        windowrulev2 = float, title:^([Pp]icture[-s]?[Ii]n[-s]?[Pp]icture)(.*)$

        # Some blur
        windowrulev2 = opacity 0.80 0.80,class:^(code)$
        windowrulev2 = opacity 0.80 0.80,class:^(zen)$
        windowrulev2 = opacity 0.80 0.80,class:^(brave)$
        windowrulev2 = opacity 0.80 0.80,class:^(amberol)$
        windowrulev2 = opacity 0.80 0.80,class:^(vesktop)$
        windowrulev2 = opacity 0.80 0.80,class:^(discord)$
        windowrulev2 = opacity 0.80 0.80,class:^(nautilus)$
        windowrulev2 = opacity 0.80 0.80,class:^(thunar)$
        windowrulev2 = opacity 0.80 0.80,class:^(rofi)$
        
        # Tearing
        windowrulev2 = immediate,class:(steam_app)
        
        # No shadow for tiled windows
        windowrulev2 = noshadow,floating:0
        
        ######### Layer rules ########
        layerrule = xray 1, .*
      # layerrule = noanim, .*
        layerrule = noanim, walker
        layerrule = noanim, selection
        layerrule = noanim, overview
        layerrule = noanim, anyrun
        layerrule = noanim, indicator.*
        layerrule = noanim, osk
        layerrule = noanim, hyprpicker
        layerrule = blur, shell:*
        layerrule = ignorealpha 0.6, shell:*

        layerrule = noanim, noanim
        layerrule = blur, gtk-layer-shell
        layerrule = ignorezero, gtk-layer-shell
        layerrule = blur, launcher
        layerrule = ignorealpha 0.5, launcher
        layerrule = blur, notifications
        layerrule = ignorealpha 0.69, notifications

        # Waybar Blur
        layerrule = blur, waybar
        layerrule = ignorealpha 0.05, waybar
        layerrule = ignorezero, waybar
        
        # Rofi Blur (maybe)
        layerrule = blur, rofi
        layerrule = ignorealpha 0.05, rofi
        layerrule = ignorezero, rofi
        
        # ags
      # layerrule = animation slide top, sideleft.*
      # layerrule = animation slide top, sideright.*
      # layerrule = blur, session
      # layerrule = 
      # layerrule = blur, bar
      # layerrule = ignorealpha 0.6, bar
      # layerrule = blur, corner.*
      # layerrule = ignorealpha 0.6, corner.*
      # layerrule = blur, dock
      # layerrule = ignorealpha 0.6, dock
      # layerrule = blur, indicator.*
      # layerrule = ignorealpha 0.6, indicator.*
      # layerrule = blur, overview
      # layerrule = ignorealpha 0.6, overview
      # layerrule = blur, cheatsheet
      # layerrule = ignorealpha 0.6, cheatsheet
      # layerrule = blur, sideright
      # layerrule = ignorealpha 0.6, sideright
      # layerrule = blur, sideleft
      # layerrule = ignorealpha 0.6, sideleft
      # layerrule = blur, indicator*
      # layerrule = ignorealpha 0.6, indicator*
      # layerrule = blur, osk
      # layerrule = ignorealpha 0.6, osk
      '';
      };
    };
  }

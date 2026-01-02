{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "center, title:^(Open File)(.*)$"
      "center, title:^(Select a File)(.*)$"
      "center, title:^(Choose wallpaper)(.*)$"
      "center, title:^(Open Folder)(.*)$"
      "center, title:^(Save As)(.*)$"
      "center, title:^(Library)(.*)$"
      "center, title:^(File Upload)(.*)$"
      
      # Dialogs (floating)
      "float,title:^(Open File)(.*)$"
      "float,title:^(Select a File)(.*)$"
      "float,title:^(Choose wallpaper)(.*)$"
      "float,title:^(Open Folder)(.*)$"
      "float,title:^(Save As)(.*)$"
      "float,title:^(Library)(.*)$"
      "float,title:^(File Upload)(.*)$"
    # "noblur,.*"
    # "opacity 0.89 override 0.89 override, .*" # Applies transparency to EVERY WINDOW
    # "float, ^(blueberry.py)$"
    # "float, ^(steam)$"
    # "float, ^(guifetch)$" # FlafyDev/guifetch
    
    # Tearing
    # "immediate,.*.exe"
    ];
    
    windowrulev2 = [
      "bordercolor rgba(ECB2FFAA) rgba(ECB2FF77),pinned:1"
      "tile, class:(dev.warp.Warp)"
      "float, title:^([Pp]icture[-s]?[Ii]n[-s]?[Pp]icture)(.*)$"
      
      # Some blur
      "opacity 0.80 0.80,class:.*" # SystemWide transparency for blur effect
      
      # "opacity 0.80 0.80,class:^(code)$"
      # "opacity 0.80 0.80,class:^(zen)$"
      # "opacity 0.80 0.80,class:^(brave)$"
      # "opacity 0.80 0.80,class:^(amberol)$"
      # "opacity 0.80 0.80,class:^(vesktop)$"
      # "opacity 0.80 0.80,class:^(discord)$"
      # "opacity 0.80 0.80,class:^(nautilus)$"
      # "opacity 0.80 0.80,class:^(thunar)$"
      # "opacity 0.80 0.80,class:^(rofi)$"
      
      # Tearing
      "immediate,class:(steam_app)"
      
      # No shadow for tiled windows
      "noshadow,floating:0"
    ];
    
    layerrule = [
      "xray 1, .*"
      # "noanim, .*"
      "noanim, walker"
      "noanim, selection"
      "noanim, overview"
      "noanim, anyrun"
      "noanim, indicator.*"
      "noanim, osk"
      "noanim, hyprpicker"
      "blur, shell:*"
      "ignorealpha 0.6, shell:*"
      
      "noanim, noanim"
      "blur, gtk-layer-shell"
      "ignorezero, gtk-layer-shell"
      "blur, launcher"
      "ignorealpha 0.5, launcher"
      "blur, notifications"
      "ignorealpha 0.69, notifications"
      
      # Waybar Blur
      "blur, waybar"
      "ignorealpha 0.05, waybar"
      "ignorezero, waybar"
      
      
      "blur, logout_dialog"
      
      "blur, class:^(swww)$"
      
      "blur, wofi"
      "ignorealpha 0.05, wofi"
      "ignorezero, wofi"
      
      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "ignorealpha 0.5, swaync-control-center"
      "ignorealpha 0.5, swaync-notification-window"
    ];
  };
}
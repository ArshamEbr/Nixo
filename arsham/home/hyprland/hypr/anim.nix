{
  wayland.windowManager.hyprland.settings = {
    animations = {
      enabled = true;
      bezier = [
        "vividGlow, 0.3, 1.1, 0.6, 1.0"
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
        "md2, 0.4, 0, 0.2, 1"
        "easeSoft, 0.25, 0.1, 0.25, 1"
        "easeOutQuick, 0, 0.55, 0.45, 1"
      ];
      
      animation = [
      "windows, 1, 4, md3_decel, popin 10%"
      "windowsIn, 1, 3.6, softAcDecel, popin 5%"
      "windowsOut, 1, 4.6, crazyshot, slide"
      "windowsMove, 1, 4, softAcDecel, slide"
      "border, 1, 25, easeOutQuick"
      "fade, 1, 6, md3_decel"
      "layersIn, 1, 3.2, md3_decel, popin"
      "layersOut, 1, 2.6, menu_accel, popin"
      "fadeLayersIn, 1, 2, menu_decel"
      "fadeLayersOut, 1, 4.5, easeOutQuick"
      "workspaces, 1, 6, menu_decel, slide"
      "workspaces, 1, 2.5, softAcDecel, slide"
      "workspaces, 1, 6, menu_decel, slidefade 10%"
      "specialWorkspace, 1, 2, md3_decel, slidefadevert 15%"
      "specialWorkspace, 1, 2.2, md3_decel, slidevert"
      "borderangle, 1, 90, linear, loop"
      ];
    };
  };
}
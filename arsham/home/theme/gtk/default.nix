{ 
  pkgs,
  config,
  ... 
}:

let
  ThemePKG = "catppuccin-gtk";
  ThemeName = "catppuccin-frappe-blue-standard";
  IconTheme = "BeautyLine";
  CursorTheme = "layan-cursors";
  CursorSize = 33;
in

{
  gtk = {
    enable = true;
    theme = {
      name = ThemeName;
      package = builtins.getAttr ThemePKG pkgs;
    };

    iconTheme = {
      name = IconTheme;
    };

    cursorTheme = {
      name = CursorTheme;
      size = CursorSize;
    };

    gtk2.extraConfig = ''
      gtk-cursor-theme-name = "${CursorTheme}"
      gtk-cursor-theme-size = ${toString CursorSize}
      gtk-icon-theme-name = "${IconTheme}"
      gtk-theme-name = "${ThemeName}"
    '';
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = builtins.getAttr CursorTheme pkgs;
      name = CursorTheme;
      size = CursorSize;
    };
    
    sessionVariables = {
      XCURSOR_THEME = CursorTheme;
      XCURSOR_SIZE = toString CursorSize;
    };

    packages = with pkgs; [
      gtk3
      gtk4
      nwg-look
      # GTK Themes
      catppuccin-gtk
      yaru-theme
      gnome-themes-extra
      adw-gtk3
      # Cursor Themes
      layan-cursors
      oreo-cursors-plus
      # Icon Themes
      morewaita-icon-theme
      gnome-icon-theme
      beauty-line-icon-theme
    ];
  };

  wayland.windowManager.hyprland.settings.exec-once = [
    "hyprctl setcursor ${CursorTheme} ${toString CursorSize}"
  ];

  xresources.properties = { # set cursor size and dpi for your monitor
    "Xcursor.theme" = CursorTheme;
    "Xcursor.size" = CursorSize;
    "Xft.dpi" = 172;
  };
}

{ 
  pkgs,
  ... 
}:

{
  gtk = {
    enable = true;
    theme = {
      name = "Juno-ocean";
    };

    iconTheme = {
      name = "BeautyLine";
    };

    cursorTheme = {
      name = "layan-cursors";
      size = 33;
    };

    gtk4.extraCss = ''
      @import url("file:///nix/store/33yqgjriq33n3h6q5kmd9yw3zanwfxlk-adw-gtk3-5.5/share/themes/adw-gtk3-dark/gtk-4.0/gtk.css");
    '';

    gtk2.extraConfig = ''
      gtk-cursor-theme-name = "layan-cursors"
      gtk-cursor-theme-size = 33
      gtk-icon-theme-name = "BeautyLine"
      gtk-theme-name = "Juno-ocean"
    '';
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.layan-cursors; # Layan Cursors
    name = "layan-cursors";
    size = 33;
  };

  xresources.properties = { # set cursor size and dpi for your monitor
    "Xcursor.size" = 33;
    "Xft.dpi" = 172;
    "Xcursor.theme" = "layan-cursors";
  };
  
  home.packages = with pkgs; [
    gtk3
    gtk4
    nwg-look
    # GTK Themes
    gnome-themes-extra
    juno-theme
    adw-gtk3
    # Cursor Themes
    layan-cursors
    bibata-cursors
    oreo-cursors-plus
    # Icon Themes
    morewaita-icon-theme
    gnome-icon-theme
    fluent-icon-theme
    dracula-icon-theme
    beauty-line-icon-theme
    whitesur-icon-theme
  ];
}
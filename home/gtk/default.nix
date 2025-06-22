{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs-unstable.adw-gtk3;
      };

      iconTheme = {
        name = "MoreWaita";
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      gtk4.extraCss = ''
        @import url("file:///nix/store/33yqgjriq33n3h6q5kmd9yw3zanwfxlk-adw-gtk3-5.5/share/themes/adw-gtk3-dark/gtk-4.0/gtk.css");
      '';

      gtk2.extraConfig = ''
        gtk-cursor-theme-name = "Bibata-Modern-Classic"
        gtk-cursor-theme-size = 24
        gtk-icon-theme-name = "MoreWaita"
        gtk-theme-name = "adw-gtk3-dark"
      '';
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs-unstable.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    xresources.properties = { # set cursor size and dpi for your monitor
      "Xcursor.size" = 24;
      "Xft.dpi" = 172;
      "Xcursor.theme" = "Bibata-Modern-Classic";
    };
    
    home.packages = with pkgs-unstable; [
      gtk3
      gtk4
      adw-gtk3
      morewaita-icon-theme
      nwg-look
    ];
  }
{ pkgs, config, lib, user, pkgs-unstable, inputs, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
        gtk-icon-theme-name=MoreWaita
        gtk-theme-name=adw-gtk3-dark
      '';

      ".config/gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-cursor-theme-name=Bibata-Modern-Classic
          gtk-cursor-theme-size=24
          gtk-icon-theme-name=MoreWaita
          gtk-theme-name=adw-gtk3-dark
      '';

      ".config/gtk-4.0/gtk.css".text = ''
        @import url("file:///nix/store/33yqgjriq33n3h6q5kmd9yw3zanwfxlk-adw-gtk3-5.5/share/themes/adw-gtk3-dark/gtk-4.0/gtk.css");
      '';

      ".gtkrc-2.0".text = ''
          gtk-cursor-theme-name = "Bibata-Modern-Classic"
          gtk-cursor-theme-size = 24
          gtk-icon-theme-name = "MoreWaita"
          gtk-theme-name = "adw-gtk3-dark"
      '';

      ".Xresources".text = ''
        Xcursor.size: 24
        Xcursor.theme: Bibata-Modern-Classic
        Xft.dpi: 172
      '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
      gtk3
      gtk4
      adw-gtk3
      morewaita-icon-theme
    ];
  }
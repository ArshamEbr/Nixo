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
      };
    };
    environment.systemPackages = with pkgs-unstable; [
      adw-gtk3
      (morewaita-icon-theme.overrideAttrs {
        src = inputs.morewaita;
      })
    ];
  }

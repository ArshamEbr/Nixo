{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/hypr/hyprland.conf".text = ''
          source=~/.config/hypr/env.conf
          source=~/.config/hypr/execs.conf
          source=~/.config/hypr/general.conf
          source=~/.config/hypr/rules.conf
          source=~/.config/hypr/colors.conf
          source=~/.config/hypr/keybinds.conf
        '';
      };
    };
    programs.hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
  }

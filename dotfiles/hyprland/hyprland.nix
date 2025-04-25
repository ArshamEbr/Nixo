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
    users.users.${user.name}.packages = with pkgs-unstable; [
      hyprland
    ];
  #  hyprland = {
  #    enable = true;
  #    package = pkgs-unstable.hyprland;
  #  };
  }

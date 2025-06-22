{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      portalPackage = pkgs-unstable.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.enableXdgAutostart = true;
    };
  }
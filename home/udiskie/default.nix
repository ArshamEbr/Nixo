{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    services.udiskie = {
      enable = true;
      notify = true;
      tray = "auto";
    };
  }
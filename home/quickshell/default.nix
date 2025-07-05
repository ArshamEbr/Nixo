{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.quickshell = {
      enable = true;
      package = pkgs-unstable.quickshell;
      config = {};
    };
  }
{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.mpv = {
      enable = true;
      package = pkgs-unstable.mpv;
      config = {
        keep-open = true;
      };
    };
  }
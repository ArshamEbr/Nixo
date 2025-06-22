{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.obs-studio = {
      enable = true;
      package = pkgs-unstable.obs-studio;
      plugins = with pkgs-unstable.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    };
  }
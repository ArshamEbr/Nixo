{ pkgs, config, lib, user, pkgs-unstable, ... }:{
  
    programs.obs-studio = {
      enable = true;
      package = pkgs-unstable.obs-studio;
      plugins = [ 
        pkgs-unstable.obs-studio-plugins.wlrobs
        pkgs-unstable.obs-studio-plugins.obs-pipewire-audio-capture
        pkgs-unstable.obs-studio-plugins.obs-vaapi
      ];
    };
  }
{ pkgs, config, lib, user, pkgs-unstable, ... }:{

#  dotfiles = {
#      username = "${user.name}";
#      files = {
#      ".config/".text = ''
#      '';
#      };
#  };
    environment.systemPackages = with pkgs-unstable; [
      (obs-studio.override {
        plugins = with unstable.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          obs-vaapi
        ];
      })
    ];
  }

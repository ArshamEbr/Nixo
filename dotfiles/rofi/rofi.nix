{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/rofi/config.rasi".text = ''
        configuration {
        font: "SpaceMono Nerd Font 11";
        location: 0;
        modi: "drun,run,window";
        show-icons: true;
        xoffset: 0;
        yoffset: 0;
        }
        @theme "solarized"
      '';
      };
    };
    environment.systemPackages = with pkgs-unstable; [
      rofi
    ];
  }

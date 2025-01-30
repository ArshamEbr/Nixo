{config, pkgs, inputs, lib, ... }:
{
  services.hyprpaper.enable = true;

  services.hyprpaper.settings = {
  ipc = "off";
  splash = true;
  splash_offset = 2.0;

  preload =
    [ "/home/arsham/Backgrounds/Aurora.jpg" ];

  wallpaper = [
    ", /home/arsham/Backgrounds/Aurora.jpg"
  ];
  };
}
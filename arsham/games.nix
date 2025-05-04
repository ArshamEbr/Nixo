{ pkgs, pkgs-unstable, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      heroic
      lutris
      protonup-qt
      wine64
      winetricks
      antimicrox
    ];
  };
}

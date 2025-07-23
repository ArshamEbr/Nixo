/**
Configures the SDDM display manager with a custom theme and a set of remote wallpapers.
Fetches wallpapers by URL and hash, applies them as backgrounds, and enables SDDM with Wayland support and additional Qt settings.
*/

{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:

let
  wall.name = "orange-train-at-sunset";
in

let
  wallpapers = {
    mitsu = {
      name = "mitsu.mp4";
      url = "https://raw.githubusercontent.com/ArshamEbr/nixo/stable/resources/wallpapers/mitsu.mp4";
      hash = "sha256-wVGzVvvb3uPtY/iBtyvUjzKCqLBq6mLeXK+KIcQubNQ=";
    };
    l-from-death-note = {
      name = "l-from-death-note.mp4";
      url = "https://raw.githubusercontent.com/ArshamEbr/Nixo/test/resources/wallpapers/l-from-death-note.mp4";
      hash = "sha256-FHp1X490lBlY4Y2wzsuh13U4Re7NmL76ui71NRWr8LY=";
    };
    anime-girl-rain = {
      name = "anime-girl-rain.mp4";
      url = "https://raw.githubusercontent.com/ArshamEbr/Nixo/test/resources/wallpapers/anime-girl-rain.mp4";
      hash = "sha256-nGgRRMa3Z4ivpTO829BnfvpkEeexTWS6tbW20TRyubA=";
    };
    beach-with-palm-trees = {
      name = "beach-with-palm-trees.mp4";
      url = "https://raw.githubusercontent.com/ArshamEbr/Nixo/test/resources/wallpapers/beach-with-palm-trees.mp4";
      hash = "sha256-eLyaGm+JKL0gzyxI56Co2kMpAOWqFQtkdywuL1E0iYc=";
    };
    orange-train-at-sunset = {
      name = "orange-train-at-sunset.mp4";
      url = "https://raw.githubusercontent.com/ArshamEbr/Nixo/test/resources/wallpapers/orange-train-at-sunset.mp4";
      hash = "sha256-plM55EKxEagVyBGXSQAb1fpxHO83yDmoJEkTzXsMTQE=";
    };
    waiting-snow = {
      name = "waiting-snow.gif";
      url = "https://raw.githubusercontent.com/ArshamEbr/Nixo/test/resources/wallpapers/waiting-snow.gif";
      hash = "sha256-ykQ3rf1xMGGFCk37xO4BkMZV+ZEOgAODQm6NqbEev3Q=";
    };
  };
  
  fetchedWallpapers = pkgs.lib.mapAttrs (_: wp: pkgs.fetchurl wp) wallpapers;
  
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "rei"; # silvia, ken, rei
    extraBackgrounds = pkgs.lib.attrValues fetchedWallpapers;
    theme-overrides = {
      "LoginScreen".background = fetchedWallpapers.${wall.name}.name;
      "LockScreen".background = fetchedWallpapers.${wall.name}.name;
    };
  };
in
{
  environment.systemPackages = [ sddm-theme ];
  qt.enable = true;
  services.displayManager.sddm = {
    package = pkgs-stable.kdePackages.sddm;
    enable = true;
    wayland.enable = true;
    theme = sddm-theme.pname;
    extraPackages = sddm-theme.propagatedBuildInputs;
    settings.General = {
      GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
      InputMethod = "qtvirtualkeyboard";
    };
  };
}
{ 
  pkgs,
  ... 
}:

{
  config = {
    environment.systemPackages = with pkgs; [
      heroic
      lutris
      protonup-qt
      wine64
      wine
      winetricks
      antimicrox
    ];
  };
}

{
  pkgs,
  ...
}:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      thumbfast
      quality-menu
    ];

    config = {
      cache = "yes";
      osc = "yes";
      keep-open = true;
    };

    profiles = {
      music = {
        "audio-display" = "no";
        "keep-open" = "yes";
        "term-playing-msg" = "▶ /$/{filename}/";
      };
      video = {
        "vo" = "gpu-next";
        "hwdec" = "auto-safe";
      };
    };
  };
  home.file.".config/mpv/scripts/visualizer.lua".source = ../../../resources/scripts/visualizer.lua;
}
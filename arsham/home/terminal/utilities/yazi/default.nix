{
  pkgs,
  ...
}:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = false;

    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
        linemode = "size";
        scrolloff = 3;
      };

      preview = {
        max_width = 120;
        max_height = 40;
        cache = true;
      };

      opener = {
        play = [ "mpv" ];
      };

      plugin = {};
    };
  };
}
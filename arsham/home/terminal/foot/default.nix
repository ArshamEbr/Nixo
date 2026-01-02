{ 
  pkgs,
  ...
}:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish";
        term = "xterm-256color";
        title = "foot";
        font = "SpaceMono Nerd Font:size=11";
        letter-spacing = 0;
        dpi-aware = "no";
        pad = "25x25";
        bold-text-in-bright = "no";
        selection-target = "both";
      };

      scrollback.lines = 10000;

      cursor = {
        style = "beam";
        beam-thickness = 1.5;
      };

      colors = {
        cursor = "0F131C DFE2EF";
        alpha = 0.7;
        background = "0F131C";
        foreground = "DFE2EF";
        regular0 = "0F131C";
        regular1 = "FFB4AB";
        regular2 = "D7E3FF";
        regular3 = "D7E3FF";
        regular4 = "D7E3FF";
        regular5 = "E0E2FF";
        regular6 = "AAC7FF";
        regular7 = "C1C6D6";
        bright0 = "0F131C";
        bright1 = "FFB4AB";
        bright2 = "005CBA";
        bright3 = "D7E3FF";
        bright4 = "D7E3FF";
        bright5 = "E0E2FF";
        bright6 = "AAC7FF";
        bright7 = "C1C6D6";
      };
  
      key-bindings = {
        scrollback-up-page = "Page_Up";
        scrollback-down-page = "Page_Down";
        clipboard-copy = "Control+c";
        clipboard-paste = "Control+v";
        search-start = "Control+f";
      };

      search-bindings = {
        cancel = "Escape";
        find-prev = "Shift+F3";
        find-next = "F3 Control+G";
      };

      text-bindings = {
        "\\x01" = "Mod4+a";
        "\\x03" = "Mod4+c";
        "\\x0C" = "Mod4+l";
        "\\x0f" = "Mod4+w";
        "\\x12" = "Mod4+r";
        "\\x1A" = "Mod4+z";
        "\\x16" = "Mod4+v";
        "\\x18" = "Mod4+x";
      };

      url = {};
      csd = {};
      url-bindings = {};
      mouse-bindings = {};
    };
  };
}
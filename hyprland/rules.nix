{config, pkgs, inputs, lib, ... }: 
{

wayland.windowManager.hyprland.settings = {

  # Rules Are RULES!

# ######## Window rules ########
windowrule = [
   # "noblur,.*"
   #"opacity 0.89 override 0.89 override, .*" # Applies transparency to EVERY WINDOW
   "opacity 0.92 0.92, code"
   "opacity 0.92 0.92, zen"
   "opacity 0.92 0.92, brave"
  # "opacity 0.92 0.92, amberol"
   "float, ^(blueberry.py)$"
   "float, ^(steam)$"
   "float, ^(guifetch)$ # FlafyDev/guifetch"
   
   "center, title:^(Open File)(.*)$"
   "center, title:^(Select a File)(.*)$"
   "center, title:^(Choose wallpaper)(.*)$"
   "center, title:^(Open Folder)(.*)$"
   "center, title:^(Save As)(.*)$"
   "center, title:^(Library)(.*)$"
   "center, title:^(File Upload)(.*)$"
   
   # Dialogs
   "float,title:^(Open File)(.*)$"
   "float,title:^(Select a File)(.*)$"
   "float,title:^(Choose wallpaper)(.*)$"
   "float,title:^(Open Folder)(.*)$"
   "float,title:^(Save As)(.*)$"
   "float,title:^(Library)(.*)$"
   "float,title:^(File Upload)(.*)$"
   
   # Tearing
   "immediate,.*\.exe"
   ];
   
   windowrulev2 = [
     ######### Window rules v2 #########
     "bordercolor rgba(ECB2FFAA) rgba(ECB2FF77),pinned:1"
     "tile, class:(dev.warp.Warp)"
     "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
   
     # Tearing
     "immediate,class:(steam_app)"
   
     # No shadow for tiled windows
     "noshadow,floating:0"
   ];
   
   # ######## Layer rules ########
   layerrule = [
   
   "xray 1, .*"
   # "noanim, .*"
   "noanim, walker"
   "noanim, selection"
   "noanim, overview"
   "noanim, anyrun"
   "noanim, indicator.*"
   "noanim, osk"
   "noanim, hyprpicker"
   "blur, shell:*"
   "ignorealpha 0.6, shell:*"
   
   "noanim, noanim"
   "blur, gtk-layer-shell"
   "ignorezero, gtk-layer-shell"
   "blur, launcher"
   "ignorealpha 0.5, launcher"
   "blur, notifications"
   "ignorealpha 0.69, notifications"
   
   # ags
   "animation slide top, sideleft.*"
   "animation slide top, sideright.*"
   "blur, session"
   
   "blur, bar"
   "ignorealpha 0.6, bar"
   "blur, corner.*"
   "ignorealpha 0.6, corner.*"
   "blur, dock"
   "ignorealpha 0.6, dock"
   "blur, indicator.*"
   "ignorealpha 0.6, indicator.*"
   "blur, overview"
   "ignorealpha 0.6, overview"
   "blur, cheatsheet"
   "ignorealpha 0.6, cheatsheet"
   "blur, sideright"
   "ignorealpha 0.6, sideright"
   "blur, sideleft"
   "ignorealpha 0.6, sideleft"
   "blur, indicator*"
   "ignorealpha 0.6, indicator*"
   "blur, osk"
   "ignorealpha 0.6, osk"
   ];
  };
}

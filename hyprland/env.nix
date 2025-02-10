{config, pkgs, ... }: 
{

wayland.windowManager.hyprland.settings = {
  env = [

  "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/renderD128" 
  "QT_IM_MODULE, fcitx"
  "XMODIFIERS, @im=fcitx"
  #GTK_IM_MODULE, wayland   # Crashes electron apps in xwayland
  #GTK_IM_MODULE, fcitx     # My Gtk apps no longer require this to work with fcitx5 hmm  
  "SDL_IM_MODULE, fcitx"
  "GLFW_IM_MODULE, ibus"
  "INPUT_METHOD, fcitx"
  
  # ############ Themes #############
  "QT_QPA_PLATFORM, wayland"
  "QT_QPA_PLATFORMTHEME, qt5ct"
  # "QT_STYLE_OVERRIDE,kvantum"
  "WLR_NO_HARDWARE_CURSORS, 1"
  "XCURSOR_SIZE,24"
  # ######## Screen tearing #########
  # "WLR_DRM_NO_ATOMIC, 1"

  ];

};
}


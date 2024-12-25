{config, pkgs, ... }: 
{

wayland.windowManager.hyprland.settings = {
# ######### Input method ########## 
# See https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland

env = [
  
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

# ############ Others #############

];

};
}


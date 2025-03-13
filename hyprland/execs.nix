{config, pkgs, ... }: 
{

wayland.windowManager.hyprland.settings = {

exec-once = [ 

# Live wallpaper (mpvpaper)
#"mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes'"

# Static and gif wallpaper (swww)
"swww-daemon --format xrgb"
#"swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1"

# Random stuff
"/usr/lib/geoclue-2.0/demos/agent & gammastep"
"ags &"

# Sound Enhancer
"easyeffects --gapplication-service &"

# Input method
"fcitx5"

# Core components (authentication, lock screen, notification daemon)
"gnome-keyring-daemon --start --components=secrets"
"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1"
"hypridle"
"dbus-update-activation-environment --all"
"sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # Some fix idk
"hyprpm reload"
"polkit-kde-authentication-agent-1"

# Clipboard: history
# "wl-paste --watch cliphist store &"
"wl-paste --type text --watch cliphist store"
"wl-paste --type image --watch cliphist store"

# Cursor
"hyprctl setcursor Bibata-Modern-Classic 24"

# Gestures
"touchegg"

# Bluetooth
# "sleep 4 && antimicrox --tray --hidden &" # for joysticks

# Network Manager
#"nm-applet &"

# Remote Desktop
#"~/.local/bin/sunshine &"

# Hyprlock
"hyprlock"

# Rebind the dGPU
"sleep 7 && reattach_safe.sh"

# Startup Sound
"paplay ~/nixo/resources/sfx/startup.mp3 & disown"

];

exec = [

# Bluetooth
"blueman-tray &"

# Allow GPU enabled XWayland applications that MUST run as root
"xhost +SI:localuser:root"

];

};
}

{
  wayland.windowManager.hyprland.settings = {
    exec = [
      # Bluetooth
      "blueman-tray &"
      
      # Allow GPU enabled XWayland applications that MUST run as root
      "xhost +SI:localuser:root"
    ];
      
    exec-once = [
      # Live wallpaper (mpvpaper) pick one!
    #  "mpvpaper '*' '/home/arsham/nixo/resources/wallpapers/girl-seaside.mp4' -o '--loop-file=yes'"
    #  "mpvpaper '*' '/home/arsham/nixo/resources/wallpapers/the-wedding.mp4' -o '--loop-file=yes'"
    #  "mpvpaper '*' '/home/arsham/nixo/resources/wallpapers/blue-haired-blind-girl.mp4' -o '--loop-file=yes'"
    #  "mpvpaper '*' '/home/arsham/nixo/resources/wallpapers/mitsu.mp4' -o '--loop-file=yes'"
      
      # Static and gif wallpaper (swww)
      "swww-daemon --format argb"
    #  "swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1"
      
      # Bar
      "waybar &"
      
      # Input method
      "fcitx5"
      
      # Core components (authentication, lock screen, notification daemon)
      "gnome-keyring-daemon --start --components=secrets"
      "hypridle"
      "dbus-update-activation-environment --all"
      "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      
      # Clipboard: history
      # "wl-paste --watch cliphist store &"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
      
      # Gestures
      " libinput-gestures"
      
      # Network Manager
      "nm-applet &"
      
      # Remote Desktop
      # "~/.local/bin/sunshine &"
      
      # Rebind the dGPU
      "sleep 7 && reattach_safe"
      
      # Startup Sound
      "sleep 4 && notifx1 startup & disown"
      
      # Notification daemon
      # "mako &"
      "swaync &"
      
      # Turn on battery conservation mode
    #  "battery_toggle on"
    ];
  };
}
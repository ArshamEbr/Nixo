{
  wayland.windowManager.hyprland.settings = {
    exec = [
      # Bluetooth
      "blueman-tray &"
  
      # Allow GPU enabled XWayland applications that MUST run as root
      "xhost +SI:localuser:root"
    ];
  
    exec-once = [
      # Live wallpaper (mpvpaper)
      # "mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes'"
  
      # Static and gif wallpaper (swww)
    #  "swww-daemon --format xrgb"
      # "swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1"
  
      # Random stuff and bar
      # "/usr/lib/geoclue-2.0/demos/agent & gammastep"
      "waybar &"
      # "ags &"
  
      # Sound Enhancer
      "easyeffects --gapplication-service &"
  
      # Input method
      "fcitx5"
  
      # Core components (authentication, lock screen, notification daemon)
      "gnome-keyring-daemon --start --components=secrets"
      "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1"
      "hypridle"
      "dbus-update-activation-environment --all"
      "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "hyprpm reload"
      "polkit-kde-authentication-agent-1"
  
      # Clipboard: history
      # "wl-paste --watch cliphist store &"
      "wl-paste --type text --watch cliphist store"
      "wl-paste --type image --watch cliphist store"
  
      # Cursor
      "hyprctl setcursor layan-cursors 33"
  
      # Gestures
      "touchegg"
  
      # Network Manager
      "nm-applet &"
  
      # Remote Desktop
      # "~/.local/bin/sunshine &"
  
      # Hyprlock (LockScreen)
    #  "hyprlock"
  
      # Rebind the dGPU
      "sleep 7 && reattach_safe"
  
      # Startup Sound
      "notifx1 startup & disown"
  
      # Notification daemon
      # "mako &"
      "swaync &"
  
      # Disk manager
      "udiskie -t &"
  
      # idk
      #"/nix/store/qkj4b3si2xbry58xslhm1vrixhxrvskp-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
  
      # "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    ];
  };
}
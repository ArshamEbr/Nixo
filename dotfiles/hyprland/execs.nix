{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/execs.conf".text = ''

        # Bluetooth
        exec = blueman-tray &
        # exec-once = sleep 4 && antimicrox --tray --hidden & # for joysticks

        # Allow GPU enabled XWayland applications that MUST run as root
        exec = xhost +SI:localuser:root
        
        # Live wallpaper (mpvpaper)
        # exec-once = mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes'

        # Static and gif wallpaper (swww)
        exec-once = swww-daemon --format xrgb
        # exec-once = swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1

        # Random stuff and bar
        exec-once = /usr/lib/geoclue-2.0/demos/agent & gammastep
        exec-once = waybar &
        # exec-once = ags &

        # Sound Enhancer
        exec-once = easyeffects --gapplication-service &

        # Input method
        exec-once = fcitx5

        # Core components (authentication, lock screen, notification daemon)
        exec-once = gnome-keyring-daemon --start --components=secrets
        exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1
        exec-once = hypridle
        exec-once = dbus-update-activation-environment --all
        exec-once = sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = hyprpm reload
        exec-once = polkit-kde-authentication-agent-1

        # Clipboard: history
        # exec-once = wl-paste --watch cliphist store &
        exec-once = wl-paste --type text --watch cliphist store
        exec-once = wl-paste --type image --watch cliphist store

        # Cursor
        exec-once = hyprctl setcursor Bibata-Modern-Classic 24

        # Gestures
        exec-once = touchegg

        # Network Manager
        exec-once = nm-applet &

        # Remote Desktop
        # exec-once = ~/.local/bin/sunshine &

        # Hyprlock (LockScreen)
        exec-once = hyprlock

        # Rebind the dGPU
        exec-once = sleep 7 && reattach_safe

        # Startup Sound
        exec-once = notifx1 startup & disown

        # Notif daemon
        exec-once = mako &
        
        # Disk manager
        exec-once = udiskie -t &

        # idk
      #  exec-once = /nix/store/qkj4b3si2xbry58xslhm1vrixhxrvskp-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
      '';
      };
    };
  }

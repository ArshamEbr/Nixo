{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    services.hypridle = {
      enable = true;
      package = pkgs-unstable.hypridle;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
        };
      
        # Brightness dim and restore
        listener = [
          {
            timeout = 180;
            on-timeout = "brightnessctl | grep 'Current' | awk '{ print $3 }' > ~/.cache/idle-brightness && brightnessctl set 1%";
            on-resume = "brightnessctl set $(cat ~/.cache/idle-brightness)";
          }
      
          # Lock screen
          {
            timeout = 420;
            on-timeout = "pidof hyprlock || hyprlock";
          }
      
          # DPMS off/on with file guard
          {
            timeout = 600;
            on-timeout = "[ -f \"/tmp/dpms_off\" ] || { hyprctl dispatch dpms off && touch /tmp/dpms_off; }";
            on-resume = "[ ! -f \"/tmp/dpms_off\" ] || { hyprctl dispatch dpms on && rm -f /tmp/dpms_off; }";
          }
      
          # Suspend unless Steam or Looking Glass are running
          {
            timeout = 7200;
            on-timeout = "pidof steam || pidof looking-glass-client || systemctl suspend || loginctl suspend";
          }
        ];
      };
    };
  }
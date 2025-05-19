{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/hypridle.conf".text = ''
        $dpms_state_file=/tmp/dpms_off
        $lock_cmd=pidof hyprlock || hyprlock
        $suspend_cmd=pidof steam || pidof looking-glass-client || systemctl suspend || loginctl suspend
        general {
          before_sleep_cmd=loginctl lock-session
          lock_cmd=$lock_cmd
        }
        
        listener {
          on-resume=brightnessctl set $(cat ~/.cache/idle-brightness)
          on-timeout=brightnessctl | grep 'Current' | awk '{ print $3 }' > ~/.cache/idle-brightness && brightnessctl set 1%
          timeout=180
        }
        
        listener {
          on-timeout=$lock_cmd
          timeout=420
        }
        
        listener {
          on-resume=[ ! -f "$dpms_state_file" ] || { hyprctl dispatch dpms on && rm -f "$dpms_state_file"; }
        
          on-timeout=[ -f "$dpms_state_file" ] || { hyprctl dispatch dpms off && touch "$dpms_state_file"; }
        
          timeout=600
        }
        
        listener {
          on-timeout=$suspend_cmd
          timeout=7200
        }
      '';
      };
    };

    services.hypridle = {
      enable = true;
      package = pkgs-unstable.hypridle;
    };
  }

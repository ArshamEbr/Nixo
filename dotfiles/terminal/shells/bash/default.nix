{ pkgs, config, lib, user, pkgs-unstable, ... }:{
    programs.bash = {
      shellAliases = {
      hyprxd = "dbus-run-session Hyprland";
      hyproxd = "exec uwsm start default";
    #  firexd = "dbus-run-session wayfire";
    #  fireoxd = "exec uwsm start wayfire";
      };

      loginShellInit = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          read -t 3 -p "Start Hyprland? (Will auto-launch in 3 seconds) [Y/n] " answer
          case $answer in
            [Yy]*|"") 
              exec uwsm start default
              ;;
            [Nn]*) 
              echo "Hyprland launch cancelled"
              ;;
          esac
        fi
      '';
    };
  }

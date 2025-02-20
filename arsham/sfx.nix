{ pkgs, pkgs-unstable, config, ... }:
let
  # Path to your existing script
  notifx1 = "/etc/profiles/per-user/arsham/bin/notifx1";
  
  wifiSoundScript = pkgs.writeShellScriptBin "wifi-sound" ''
    #!/run/current-system/sw/bin/bash

    case "$2" in
        up)
            ${notifx1} wifi_connected
            ;;
        down)
            ${notifx1} wifi_disconnected
            ;;
    esac
  '';
in
  {
    environment.systemPackages = [ wifiSoundScript ];

    services = {
  
      network-manager = {
        dispatcherScripts = {
          wifi-sound = {
            source = "${wifiSoundScript}/bin/wifi-sound";
            executable = true;
          };
        };
      };
  
      udev = {
        extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 usb_add"
          ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 usb_remove"
        '';
      };
    };
  }
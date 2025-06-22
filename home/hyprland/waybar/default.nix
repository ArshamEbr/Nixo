{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.waybar = {
      enable = false;
      package = pkgs-unstable.waybar;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 0;
          spacing = 0;
    
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
    
          modules-center = [
            "custom/gpuinfo"
            "temperature"
            "cpu"
            "clock"
            "memory"
            "disk"
          ];
    
          modules-right = [
            "tray"
            "network"
            "custom/network"
            "pulseaudio"
            "backlight"
            "battery"
            "idle_inhibitor"
            "custom/power"
            "custom/notification"
          ];
    
          "hyprland/window" = {
            format = "{}";
            separate-outputs = true;
            rewrite = {
              "arsham@hyprland =(.*)" = "$1 ";
              "(.*) — Mozilla Firefox" = "$1 󰈹";
              "(.*)Mozilla Firefox" = "Firefox 󰈹";
              "(.*) - Visual Studio Code" = "$1 󰨞";
              "(.*)Visual Studio Code" = "Code 󰨞";
              "(.*) — Dolphin" = "$1 󰉋";
              "(.*)Spotify" = "Spotify 󰓇";
              "(.*)Spotify Premium" = "Spotify 󰓇";
              "(.*)Steam" = "Steam 󰓓";
            };
            max-length = 40;
          };
    
          "cpu" = {
            format = "󰻠 {usage}%";
            tooltip = false;
          };
    
          "memory" = {
            format = "󰍛 {}%";
            tooltip = false;
          };
    
          "temperature" = {
            hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
            critical-threshold = 90;
            format-critical = "{temperatureC}°C {icon}";
            format = " {temperatureC}°C";
          };
    
          "custom/gpuinfo" = {
            exec = "bash -c '~/.config/waybar/scripts/gpuinfo.sh'";
            return-type = "json";
            format = "{}";
            tooltip = false;
            interval = 1;
          };
    
          "custom/network" = {
            format = "{}";
            exec = "bash -c '~/.config/waybar/scripts/network.sh'";
            return-type = "json";
            interval = 1;
            tooltip = false;
          };
    
          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
    
          "custom/power" = {
            format = "⏻";
            tooltip = false;
            on-click = "~/.config/waybar/scripts/powermenu.sh";
          };
    
          "clock" = {
            format = " {:%H:%M}";
            tooltip = true;
            tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
          };
    
          "disk" = {
            interval = 30;
            format = " {percentage_used}%";
            path = "/";
          };
    
          "backlight" = {
            device = "intel_backlight";
            format = "{icon} {percent}%";
            format-icons = [ "🌑" "🌘" "🌗" "🌖" "🌕" ];
          };
    
          "battery" = {
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-icons = [
              "󰁺" "󰁻" "󰁼" "󰁽" "󰁾"
              "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"
            ];
            states = {
              critical = 15;
              warning = 30;
            };
          };
    
          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 muted";
            format-icons = {
              headphone = "󰋋";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
            tooltip = false;
          };
    
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
    
          "network" = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰈀";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
    
          "tray" = {
            spacing = 5;
          };
        }
      ];
    };
  }
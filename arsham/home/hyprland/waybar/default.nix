{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;
        margin-top = 1;
        margin-left = 6;
        margin-right = 6;
        margin-bottom = 0;

        "modules-left" = [
          "custom/logo"
          "hyprland/workspaces"
          "hyprland/window"
        ];

        "modules-center" = [
          "clock"
        ];

        "modules-right" = [
          "tray"
          "custom/network"
          "cpu"
          "memory"
          "temperature"
          "custom/gpuinfo"
          "pulseaudio"
          "backlight"
          "battery"
          "idle_inhibitor"
          "custom/notification"
          "custom/power"
        ];

        "custom/logo" = {
          format = "󱄅";
          tooltip = true;
          tooltip-format = "NixOS";
          on-click = "anyrun";
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          format = "{icon}";
          show-special = false;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰿬";
            urgent = "󰀨";
            active = "󰮯";
            default = "󰊠";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          separate-outputs = true;
          max-length = 25;
          rewrite = {
            "(.*) — Mozilla Firefox" = "󰈹 \$1";
            "(.*)Mozilla Firefox" = "󰈹 Firefox";
            "(.*) - Visual Studio Code" = "󰨞 \$1";
            "(.*)Visual Studio Code" = "󰨞 VS Code";
            "(.*) — Dolphin" = "󰉋 \$1";
            "(.*)Spotify" = "󰓇 Spotify";
            "(.*)Steam" = "󰓓 Steam";
            "(.*) - Discord" = "󰙯 \$1";
            "(.*)Discord" = "󰙯 Discord";
          };
        };

        clock = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%a %b %d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#f5c2e7'><b>{}</b></span>";
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              weeks = "<span color='#94e2d5'><b>W{}</b></span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
        };

        "custom/network" = {
          exec = "waynet";
          return-type = "json";
          interval = 3;
          on-click = "kitty -e nmtui";
        };

        cpu = {
          format = "󰻠 {usage:3}%";
          interval = 2;
          on-click = "kitty -e btop";
        };

        memory = {
          format = "󰍛 {percentage:3}%";
          format-alt = "󰍛 {used:0.1f}G";
          interval = 2;
        };

        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°";
          format-critical = "󰸁 {temperatureC}°";
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          interval = 2;
          on-click = "kitty -e btop";
        };

        "custom/gpuinfo" = {
          exec = "gpuinfo";
          return-type = "json";
          format = "󰢮 {}";
          interval = 5;
          tooltip = true;
          max-length = 20;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "󰂯 {volume}%";
          format-muted = "󰖁 Mute";
          format-icons = {
            headphone = "󰋋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󱐋 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo} | {power:.1f}W";
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰂚<span foreground='#f38ba8'><sup></sup></span>";
            none = "󰂜";
            dnd-notification = "󰂛<span foreground='#f38ba8'><sup></sup></span>";
            dnd-none = "󰂛";
            inhibited-notification = "󰂚<span foreground='#f38ba8'><sup></sup></span>";
            inhibited-none = "󰂜";
            dnd-inhibited-notification = "󰂛<span foreground='#f38ba8'><sup></sup></span>";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊";
            deactivated = "󰾫";
          };
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout -b 5";
        };

        tray = {
          icon-size = 14;
          spacing = 6;
        };
      }
    ];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono Nerd Font";
        font-weight: bold;
        font-size: 13px;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      window#waybar.empty #window {
        padding: 0;
        margin: 0;
        background: transparent;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(17, 17, 27, 0.55);
        border: 1px solid rgba(137, 180, 250, 0.12);
        border-radius: 14px;
        padding: 0 6px;
        margin: 3px 3px;
      }

      #custom-logo {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.15), rgba(137, 180, 250, 0.15));
        color: #7ebae4;
        font-size: 18px;
        padding: 0 10px 0 8px;
        margin: 3px 4px 3px 2px;
        border-radius: 10px;
      }

      #custom-logo:hover {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.3), rgba(137, 180, 250, 0.3));
        color: #89dceb;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 3px 8px;
        margin: 3px 2px;
        border-radius: 10px;
        color: #585b70;
        background: transparent;
        transition: all 0.2s ease;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: rgba(180, 190, 254, 0.12);
      }

      #workspaces button.active {
        color: #11111b;
        font-weight: bold;
        background: linear-gradient(135deg, #89b4fa 0%, #b4befe 50%, #cba6f7 100%);
        border-radius: 10px;
        box-shadow: 0 0 12px rgba(137, 180, 250, 0.4), 0 0 4px rgba(203, 166, 247, 0.3);
      }

      #workspaces button.urgent {
        color: #11111b;
        background: linear-gradient(135deg, #f38ba8 0%, #fab387 100%);
        box-shadow: 0 0 12px rgba(243, 139, 168, 0.5);
      }

      #window {
        color: #9399b2;
        padding: 0 10px;
        font-weight: normal;
        font-size: 12px;
      }

      #clock {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.12), rgba(245, 194, 231, 0.12));
        color: #cdd6f4;
        font-size: 14px;
        padding: 0 14px;
        margin: 3px 2px;
        border-radius: 10px;
      }

      #clock:hover {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.2), rgba(245, 194, 231, 0.2));
      }

      #custom-network {
        background: linear-gradient(135deg, rgba(137, 220, 235, 0.1), rgba(116, 199, 236, 0.1));
        color: #89dceb;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #custom-network.disconnected {
        background: rgba(88, 91, 112, 0.15);
        color: #6c7086;
      }

      #custom-network:hover {
        background: linear-gradient(135deg, rgba(137, 220, 235, 0.2), rgba(116, 199, 236, 0.2));
      }

      #cpu {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.1), rgba(137, 180, 250, 0.1));
        color: #74c7ec;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #cpu:hover {
        background: linear-gradient(135deg, rgba(116, 199, 236, 0.2), rgba(137, 180, 250, 0.2));
      }

      #memory {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.1), rgba(180, 190, 254, 0.1));
        color: #cba6f7;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #memory:hover {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.2), rgba(180, 190, 254, 0.2));
      }

      #temperature {
        background: linear-gradient(135deg, rgba(148, 226, 213, 0.1), rgba(166, 227, 161, 0.1));
        color: #94e2d5;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #temperature:hover {
        background: linear-gradient(135deg, rgba(148, 226, 213, 0.2), rgba(166, 227, 161, 0.2));
      }

      #temperature.critical {
        background: linear-gradient(135deg, #f38ba8, #fab387);
        color: #11111b;
        box-shadow: 0 0 8px rgba(243, 139, 168, 0.4);
      }

      #custom-gpuinfo {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.1), rgba(250, 179, 135, 0.1));
        color: #f9e2af;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #custom-gpuinfo:hover {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.2), rgba(250, 179, 135, 0.2));
      }

      #pulseaudio {
        background: linear-gradient(135deg, rgba(245, 194, 231, 0.1), rgba(203, 166, 247, 0.1));
        color: #f5c2e7;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #pulseaudio:hover {
        background: linear-gradient(135deg, rgba(245, 194, 231, 0.2), rgba(203, 166, 247, 0.2));
      }

      #pulseaudio.muted {
        background: rgba(88, 91, 112, 0.15);
        color: #6c7086;
      }

      #backlight {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.1), rgba(245, 194, 231, 0.1));
        color: #f9e2af;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #backlight:hover {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.2), rgba(245, 194, 231, 0.2));
      }

      #battery {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.1), rgba(148, 226, 213, 0.1));
        color: #a6e3a1;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #battery:hover {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.2), rgba(148, 226, 213, 0.2));
      }

      #battery.charging,
      #battery.plugged {
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.15), rgba(148, 226, 213, 0.15));
        color: #a6e3a1;
      }

      #battery.warning {
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.15), rgba(249, 226, 175, 0.15));
        color: #fab387;
      }

      #battery.critical:not(.charging) {
        background: linear-gradient(135deg, #f38ba8, #fab387);
        color: #11111b;
        box-shadow: 0 0 8px rgba(243, 139, 168, 0.4);
      }

      #idle_inhibitor {
        background: rgba(88, 91, 112, 0.1);
        color: #6c7086;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #idle_inhibitor:hover {
        background: rgba(88, 91, 112, 0.2);
      }

      #idle_inhibitor.activated {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.15), rgba(250, 179, 135, 0.15));
        color: #f9e2af;
        box-shadow: 0 0 6px rgba(249, 226, 175, 0.3);
      }

      #custom-notification {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.1), rgba(250, 179, 135, 0.1));
        color: #f9e2af;
        padding: 0 8px;
        margin: 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #custom-notification:hover {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.2), rgba(250, 179, 135, 0.2));
      }

      #custom-power {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.12), rgba(235, 160, 172, 0.12));
        color: #f38ba8;
        padding: 0 10px;
        margin: 3px 4px 3px 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }

      #custom-power:hover {
        background: linear-gradient(135deg, #f38ba8, #fab387);
        color: #11111b;
        box-shadow: 0 0 8px rgba(243, 139, 168, 0.4);
      }

      #tray {
        padding: 0 6px;
        margin: 3px 2px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      tooltip {
        background: rgba(17, 17, 27, 0.92);
        border: 1px solid rgba(137, 180, 250, 0.15);
        border-radius: 10px;
      }

      tooltip label {
        color: #cdd6f4;
        padding: 6px;
      }
    '';
  };
}
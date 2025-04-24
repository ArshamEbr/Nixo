{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/waybar/config".text = ''
        [
          {
            "backlight": {
              "device": "intel_backlight",
              "format": "{icon} {percent}%",
              "format-icons": [
                "🌑",
                "🌘",
                "🌗",
                "🌖",
                "🌕"
              ]
            },
            "battery": {
              "format": "{icon} {capacity}%",
              "format-charging": "󰂄 {capacity}%",
              "format-icons": [
                "󰁺",
                "󰁻",
                "󰁼",
                "󰁽",
                "󰁾",
                "󰁿",
                "󰂀",
                "󰂁",
                "󰂂",
                "󰁹"
              ],
              "states": {
                "critical": 15,
                "warning": 30
              }
            },
            "clock": {
              "format": "{:%H:%M}",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
            },
            "cpu": {
              "format": " {usage}%",
              "interval": 3
            },
            "custom/launcher": {
              "format": " ",
              "on-click": "rofi -show drun",
              "tooltip": false
            },
            "custom/mpd": {
              "exec": "sanitize_output() {\n  decoded=$(printf '%b' \"${1//%/\\\\x}\" 2>/dev/null || echo \"$1\")\n  echo \"$decoded\" | \n    iconv -cf utf-8 -t utf-8//TRANSLIT 2>/dev/null |\n    tr -cd '\\11\\12\\15\\40-\\176' |  # Keep basic printable ASCII\n    sed -e 's/\\\\u[0-9a-fA-F]\\{1,4\\}//g' \\\n        -e 's/[[:cntrl:]]//g' \\\n        -e 's/^[[:space:]]*//' \\\n        -e 's/[[:space:]]*$//'\n}\nplayers=$(playerctl -l 2>/dev/null)\nmeta=\"\"\nfor player in $players; do\n  current=$(playerctl -p \"$player\" metadata --format '{{artist}} - {{title}}' 2>/dev/null)\n  [ -z \"$current\" ] || [ \"$current\" = \" - \" ] && \n    current=$(playerctl -p \"$player\" metadata --format '{{title}}' 2>/dev/null)\n  if [ -z \"$current\" ]; then\n    url=$(playerctl -p \"$player\" metadata xesam:url 2>/dev/null)\n    if [ -n \"$url\" ]; then\n      filename=$(basename \"${url%%\\?*}\")\n      current=$(sanitize_output \"$filename\")\n      current=\"${current%.*}\"\n    fi\n  fi\n  [ -z \"$meta\" ] && [ -n \"$current\" ] && meta=\"$current\"\ndone\nif [ -z \"$meta\" ]; then\n  if [ -n \"$players\" ]; then\n    meta=\"Media player paused\"\n  else\n    meta=\"No media player\"\n  fi\nfi\necho -n \"$meta\" | head -c 70 | tr -d '\\n\\r\\0'\n",
              "format": "󰝚 {}",
              "interval": 3,
              "on-click": "playerctl play-pause",
              "return-type": "string"
            },
            "custom/network": {
              "exec": "way_network",
              "interval": 1,
              "return-type": "text"
            },
            "custom/power": {
              "exec": "echo \"󰓅\" ",
              "format": "{}",
              "interval": "once",
              "on-click": "tlp_mode",
              "return-type": "text",
              "tooltip": false
            },
            "disk": {
              "format": " {percentage_used}%",
              "path": "/"
            },
            "height": 0,
            "hyprland/workspaces": {
              "active-only": false,
              "format": "{name}",
              "on-click": "activate"
            },
            "layer": "top",
            "memory": {
              "format": "  {}%",
              "interval": 3
            },
            "modules-center": [
              "temperature",
              "cpu",
              "clock",
              "memory",
              "disk"
            ],
            "modules-left": [
              "custom/launcher",
              "hyprland/workspaces",
              "custom/mpd"
            ],
            "modules-right": [
              "tray",
              "network",
              "custom/network",
              "pulseaudio",
              "backlight",
              "custom/power",
              "battery"
            ],
            "network": {
              "format-disconnected": "󰖪 Disconnected",
              "format-ethernet": "󰈀 Connected",
              "format-wifi": "{essid} {signalStrength}%",
              "on-click": "kitty -e nmtui",
              "tooltip-format": "{ifname} via {gwaddr}"
            },
            "position": "top",
            "pulseaudio": {
              "format": "{icon}  {volume}%",
              "format-icons": {
                "default": [
                  "",
                  "",
                  ""
                ]
              },
              "format-muted": "  Muted",
              "on-click": "pavucontrol"
            },
            "spacing": 0,
            "temperature": {
              "critical-threshold": 80,
              "format": " {temperatureC}°C",
              "format-critical": " {temperatureC}°C",
              "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
              "interval": 3,
              "on-click": "foot -e btop",
              "tooltip": false
            },
            "tray": {
              "spacing": 12
            }
          }
        ]
      '';
      
      # CSS
      ".config/waybar/style.css".text = ''
        * {
          border: none;
          border-radius: 8px;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          min-height: 0;
        }
        
        window#waybar {
          background: rgba(40, 40, 40, 0.602);
          color: #cdd6f4;
          border-radius: 0px;
          margin: 0px 0px 0 0px;
        }
        
        #custom-mpd {
          color:rgba(145, 229, 255, 0.961);
          font-weight: bold;
          padding: 0 10px;
        }
        
        #workspaces button,
        #clock, 
        #battery, 
        #cpu, 
        #memory, 
        #network, 
        #pulseaudio,
        #custom-launcher,
        #temperature,
        #mpd,
        #backlight,
        #disk,
        #gamemode,
        #custom-power,
        #custom-mpd,
        #custom-network,
        #tray {
          background: transparent;
          margin: 0px 3px;
          padding: 0 6px;
        }
        
        /* Active workspace */
        #workspaces button.active {
          background: rgba(117, 147, 196, 0.602);
          color:rgb(151, 188, 249);
        }
        
        /* Hover effects */
        #workspaces button:hover,
        #clock:hover,
        #battery:hover,
        #cpu:hover,
        #memory:hover,
        #network:hover,
        #pulseaudio:hover,
        #custom-launcher:hover,
        #temperature:hover,
        #mpd:hover,
        #backlight:hover,
        #disk:hover,
        #gamemode:hover,
        #custom-power:hover,
        #custom-mpd:hover,
        #custom-network:hover,
        #tray:hover {
          background: rgba(49, 50, 68, 0.602); /* Darker on hover */
        }
        
        #temperature {
          color:rgb(0, 234, 255);
        }
        
        #temperature.critical {
          color:rgb(255, 19, 19);
          animation: blink 1s infinite;
        }
        
        @keyframes blink {
          0% { opacity: 1; }
          50% { opacity: 0.5; }
          100% { opacity: 1; }
        }
      ''
      };
    };
  }

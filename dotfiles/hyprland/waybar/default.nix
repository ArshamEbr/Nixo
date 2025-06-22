{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/waybar/config".text = ''
        [
          {
            "modules-center": [
              "custom/gpuinfo",
              "temperature",
              "cpu",
              "clock",
              "memory",
              "disk"
            ],
            "modules-left": [
            //  "custom/launcher",
              "hyprland/workspaces",
              "hyprland/window"
            ],
            "modules-right": [
              "tray",
              "network",
              "custom/network",
              "pulseaudio",
              "backlight",
              "battery",
              "idle_inhibitor",
              "custom/power",
              "custom/notification"
            ],
            "hyprland/window": {
              "format": "{}",
              "separate-outputs": true,
              "rewrite": {
                "arsham@hyprland =(.*)": "$1 ",
                "(.*) — Mozilla Firefox": "$1 󰈹",
                "(.*)Mozilla Firefox": "Firefox 󰈹",
                "(.*) - Visual Studio Code": "$1 󰨞",
                "(.*)Visual Studio Code": "Code 󰨞",
                "(.*) — Dolphin": "$1 󰉋",
                "(.*)Spotify": "Spotify 󰓇",
                "(.*)Spotify Premium": "Spotify 󰓇",
                "(.*)Steam": "Steam 󰓓"
              },
              "max-length": 40
            },
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
              "on-click": "anyrun",
              "tooltip": false
            },
            "custom/network": {
              "exec": "way_network",
              "interval": 1,
              "return-type": "text",
              "tooltip": false
            },
            "custom/power": {
              "exec": "echo \"󰓅\" ",
              "format": "{}",
              "interval": "once",
              "on-click": "tlp_mode",
              "return-type": "text",
              "tooltip": false
            },
            "custom/cava_mviz" : {
              "exec" : "waybar-cava",
              "format" : "{}"
            },
            "cava" : {
              "hide_on_silence" : false,
              "framerate" : 60,
              "bars" : 10,
              "format-icons": [
                "▁",
                "▂",
                "▃",
                "▄",
                "▅",
                "▆",
                "▇",
                "█"
              ],
              "input_delay" : 1,
              "sleep_timer" : 5,
              "bar_delimiter" : 0,
              "on-click" : "playerctl play-pause"
            },
            "custom/gpuinfo" : {
              "exec" : "gpuinfo",
              "return-type" : "json",
              "format" : " {}",
              "interval" : 5,
              "tooltip" : true,
              "max-length" : 1000
            },
            "disk": {
              "format": " {percentage_used}%",
              "path": "/"
            },
            "height": 0,
            "hyprland/workspaces": {
                "active-only": false,
                "all-outputs": true, 
                "format": "{icon}",
                "show-special": false,
                "on-click": "activate",
                "on-scroll-up": "hyprctl dispatch workspace e+1",
                "on-scroll-down": "hyprctl dispatch workspace e-1",
                "persistent-workspaces": {
                  "1": [],
                  "2": [],
                  "3": [],
                  "4": [],
                  "5": [],
                },
                "format-icons": {
                  "active": "",
                  "default": ""
              } 
            },
            "layer": "top",
            "memory": {
              "format": "  {}%",
              "interval": 3
            },
            "custom/notification": {
              "tooltip": false,
              "format": " {icon} ",
              "format-icons": {
                "notification": "<span foreground='red'><sup></sup></span>",
                "none": "",
                "dnd-notification": "<span foreground='red'><sup></sup></span>",
                "dnd-none": "",
                "inhibited-notification": "<span foreground='red'><sup></sup></span>",
                "inhibited-none": "",
                "dnd-inhibited-notification": "<span foreground='red'><sup></sup></span>",
                "dnd-inhibited-none": ""
              },
              "return-type": "json",
              "exec-if": "which swaync-client",
              "exec": "swaync-client -swb",
              "on-click": "swaync-client -t -sw",
              "on-click-right": "swaync-client -d -sw",
              "escape": true
            },
            "idle_inhibitor": {
              "format": "{icon} ",
              "format-icons": {
                "activated": "󰥔",
                "deactivated": ""
              }
            },
            "bluetooth": {
              "format": "",
              "format-connected": " {num_connections}",
              "tooltip-format": " {device_alias}",
              "tooltip-format-connected": "{device_enumerate}",
              "tooltip-format-enumerate-connected": " {device_alias}",
              "on-click": "blueman-manager"
            },
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
                "headphone": "",
                "hands-free": "",
                "headset": "",
                "phone": "",
                "portable": "",
                "car": "",
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
          border-radius: 7px;
          font-family: "JetBrains Mono Nerd Font";
          font-weight: bold;
          min-height: 0;	
          font-size: 100%;
          font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
          padding: 0px;
        }
        
        window#waybar {
          background:transparent;
          border-radius: 0px;
          color: whitesmoke;
        }
        
        window#waybar.hidden {
          opacity: 0.5;
        }
        window#waybar.empty {
          background-color: transparent;
        }
        
        window#waybar.empty #window {
          padding: 0px;
          border: 0px;
          background-color: transparent;
        }
        
        #clock, 
        #battery, 
        #cpu, 
        #memory, 
        #network, 
        #pulseaudio,
        #custom-launcher,
        #temperature,
        #backlight,
        #disk,
        #gamemode,
        #custom-power,
        #custom-network,
        #custom-gpuinfo,
        #custom-notification,
        #idle_inhibitor,
        #window,
        #tray {
          background: none;
          margin: 0;
          padding: 0px 5px;
        }
        
        .modules-left,
        .modules-center,
        .modules-right {
          background: rgba(0, 0, 0, 0.4); /* Unified background */
          border-radius: 7px;
          margin: 2px;
          padding: 0 6px;
        }
        
        /* Hover effect for inner modules */
        .modules-left > *,
        .modules-center > *,
        .modules-right > * {
          margin: 0 1px;
          padding: 0px 5px;
          border-radius: 5px;
        }
        
        .modules-left > *:hover,
        .modules-center > *:hover,
        .modules-right > *:hover {
          background: rgba(49, 50, 68, 0.602);
        }
        
        #workspaces button {
          color: #6E6A86;
          box-shadow: none;
          text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          padding-left: 4px;
          padding-right: 4px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }
        
        #workspaces button.active {
          color: whitesmoke;
          border-radius: 15px 15px 15px 15px;
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }
        
        #workspaces button.focused {
          color: #d8dee9;
        }
        #workspaces button.urgent {
          color: #11111b;
          border-radius: 10px;
        }
        
        #workspaces button:hover {
          color: whitesmoke;
          border-radius: 15px;
          padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }
        
        tooltip {
          background: #1e1e2e;
          border-radius: 10px;
          border-width: 2px;
          border-style: solid;
          border-color: #11111b;
          color: #cba6f7;
        }
        
        #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        
        
        /* Hover effects */
        #clock:hover,
        #battery:hover,
        #cpu:hover,
        #memory:hover,
        #network:hover,
        #pulseaudio:hover,
        #custom-launcher:hover,
        #temperature:hover,
        #backlight:hover,
        #disk:hover,
        #gamemode:hover,
        #custom-power:hover,
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
        
        #custom-cava_mviz {
          color: #f5c2e7;
        }
        
        #cava {
        color: #f5c2e7;
        }
        
        @keyframes blink {
          0% { opacity: 1; }
          50% { opacity: 0.5; }
          100% { opacity: 1; }
        }
        
        #custom-gpuinfo {
          color: #eba0ac;
        }
      '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
      waybar
    ];
  }

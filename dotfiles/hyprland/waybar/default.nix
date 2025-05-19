{ pkgs, config, lib, user, pkgs-unstable, ... }:{

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
              "format": "{name}",
              "on-click": "activate"
            },
            "layer": "top",
            "memory": {
              "format": "  {}%",
              "interval": 3
            },
            "modules-center": [
              "custom/gpuinfo",
              "temperature",
              "cpu",
              "clock",
              "memory",
              "disk"
            ],
            "modules-left": [
              "custom/launcher",
              "hyprland/workspaces"
            ],
            "modules-right": [
              "tray",
            //  "bluetooth",
              "network",
              "custom/network",
              "pulseaudio",
              "backlight",
              "battery",
              "idle_inhibitor",
              "custom/power",
              "custom/notification"
            ],
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
        
        #workspaces button,
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
          color: @pink;
        }

        #cava {
        color: @pink;
        }
        
        @keyframes blink {
          0% { opacity: 1; }
          50% { opacity: 0.5; }
          100% { opacity: 1; }
        }
      '';
      };
    };
    users.users.${user.name}.packages = with pkgs-unstable; [
      waybar
    ];
  }

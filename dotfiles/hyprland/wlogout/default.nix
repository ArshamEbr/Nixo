{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
        ".config/wlogout/layout".text = ''
          {
              "label" : "lock",
              "action" : "loginctl lock-session",
              "text" : "Lock",
              "keybind" : "l"
          }
          {
              "label" : "hibernate",
              "action" : "systemctl hibernate || loginctl hibernate",
              "text" : "Hibernate",
              "keybind" : "h"
          }
          {
              "label" : "logout",
              "action" : "pkill Hyprland || pkill sway || pkill niri || loginctl terminate-user $USER",
              "text" : "Logout",
              "keybind" : "e"
          }
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff || loginctl poweroff",
              "text" : "Shutdown",
              "keybind" : "s"
          }
          {
              "label" : "suspend",
              "action" : "systemctl suspend || loginctl suspend",
              "text" : "Sleep",
              "keybind" : "u"
          }
          {
              "label" : "reboot",
              "action" : "systemctl reboot || loginctl reboot",
              "text" : "Reboot",
              "keybind" : "r"
          }
        '';
        
        ".config/wlogout/style.css".text = ''
          * {
              all: unset;
              background-image: none;
              transition: 400ms cubic-bezier(0.05, 0.7, 0.1, 1);
          }
          window {
              background-color: rgba(24, 27, 32, 0.2);
          
          } 
          
          button {
              background-repeat: no-repeat;
              background-position: center;
              background-size: 20%;
              background-color: transparent;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s ease-in;
              box-shadow: 0 0 10px 2px transparent;
              border-radius: 36px;
              margin: 10px;
              color: transparent;
              text-shadow: none;
          }
          
          button:active,
          button:focus,
          button:hover {
              background-size: 50%;
              box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
              color: transparent;
              transition: transform 0.2s ease, filter 0.2s ease;
          }
          
          /* SHUTDOWN */
          #shutdown {
              background-image: image(url("./icons/power.png"));
          }
          #shutdown:hover,
          #shutdown:active,
          #shutdown:focus {
              background-image: image(url("./icons/power-hover.png"));
          }
          
          /* LOGOUT */
          #logout {
              background-image: image(url("./icons/logout.png"));
          }
          #logout:hover,
          #logout:active,
          #logout:focus {
              background-image: image(url("./icons/logout-hover.png"));
          }
          
          /* REBOOT */
          #reboot {
              background-image: image(url("./icons/restart.png"));
          }
          #reboot:hover,
          #reboot:active,
          #reboot:focus {
              background-image: image(url("./icons/restart-hover.png"));
          }
          
          /* LOCK */
          #lock {
              background-image: image(url("./icons/lock.png"));
          }
          #lock:hover,
          #lock:active,
          #lock:focus {
              background-image: image(url("./icons/lock-hover.png"));
          }
          
          /* HIBERNATE */
          #hibernate {
              background-image: image(url("./icons/hibernate.png"));
          }
          #hibernate:hover,
          #hibernate:active,
          #hibernate:focus {
              background-image: image(url("./icons/hibernate-hover.png"));
          }
          
          /* SUSPEND */
          #suspend {
              background-image: image(url("./icons/sleep.png"));
          }
          #suspend:hover,
          #suspend:active,
          #suspend:focus {
              background-image: image(url("./icons/sleep-hover.png"));
          }
        '';

    #    ".config/wlogout/icons".source = ../../../resources/wlogout;
      };
    };
    users.users.${user.name}.packages = with pkgs; [
      wlogout
    ];
  }

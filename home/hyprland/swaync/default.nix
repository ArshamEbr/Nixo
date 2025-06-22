{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    services.swaync = {
      enable = true;
      package = pkgs-unstable.swaynotificationcenter;
    
      settings = {
        "$schema" = "/etc/xdg/swaync/configSchema.json";
        positionX = "right";
        positionY = "top";
        cssPriority = "user";
    
        control-center-width = 380;
        control-center-height = 860;
        control-center-margin-top = 2;
        control-center-margin-bottom = 2;
        control-center-margin-right = 1;
        control-center-margin-left = 0;
    
        notification-window-width = 400;
        notification-icon-size = 48;
        notification-body-image-height = 160;
        notification-body-image-width = 200;
    
        timeout = 4;
        timeout-low = 2;
        timeout-critical = 6;
    
        fit-to-screen = false;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = false;
        script-fail-notify = true;
    
        scripts = {
          "example-script" = {
            exec = "echo 'Do something...'";
            urgency = "Normal";
          };
        };
    
        notification-visibility = {
          "example-name" = {
            state = "muted";
            urgency = "Low";
            app-name = "Spotify";
          };
        };
    
        widgets = [
          "label"
          "buttons-grid"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
    
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = " 󰎟 ";
          };
          dnd = {
            text = "Do not disturb";
          };
          label = {
            max-lines = 1;
            text = " ";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
          volume = {
            label = "󰕾";
            show-per-app = true;
          };
          buttons-grid = {
            actions = [
              {
                label = "  ";
                command = "amixer set Master toggle";
              }
              {
                label = "  ";
                command = "nm-connection-editor";
              }
              {
                label = " 󰂯 ";
                command = "blueman-manager";
              }
              {
                label = "  ";
                command = "sh -c \"XDG_CURRENT_DESKTOP=gnome gnome-control-center\"";
              }
            ];
          };
        };
      };
    
      style = ''
        @define-color text            #ECEFF4;
        @define-color background      rgba(18, 20, 25, 0.6);
        @define-color background-alt  rgba(40, 42, 54, 0.5);
        @define-color selected        #88C0D0;
        @define-color hover           rgba(136, 192, 208, 0.5);
        @define-color urgent          #BF616A;
    
        * {
          all: unset;
          color: @text;
          font-size: 14px;
          font-family: "JetBrains Mono Nerd Font 10";
          transition: 200ms ease;
        }
    
        .blank-window {
          background: transparent;
        }
    
        .floating-notifications.background .notification-row .notification-background,
        .control-center {
          background: @background;
          border-radius: 24px;
          border: 1px solid @selected;
          box-shadow: 0 0 12px rgba(0, 0, 0, 0.6);
          margin: 18px;
          padding: 12px;
        }
    
        .notification-row {
          outline: none;
          margin: 0;
          padding: 0;
        }
    
        .notification-background {
          background: rgba(30, 32, 40, 0.4);
          border-radius: 20px;
          padding: 6px;
          margin: 10px 0;
        }
    
        .notification.critical {
          border: 2px solid @urgent;
        }
    
        .notification-content {
          margin: 12px;
        }
    
        .notification > *:last-child > * {
          min-height: 3.4em;
        }
    
        .notification-action {
          border-radius: 12px;
          background-color: @background-alt;
          color: @text;
          margin: 6px;
          border: 1px solid transparent;
          padding: 4px 12px;
        }
    
        .notification-action:hover {
          background-color: @hover;
          border: 1px solid @selected;
        }
    
        .notification-action:active {
          background-color: @selected;
          color: @background;
        }
    
        .close-button {
          background-color: transparent;
          border: 1px solid transparent;
          margin: 6px;
          padding: 4px;
          border-radius: 8px;
        }
    
        .close-button:hover {
          background-color: @selected;
        }
    
        .close-button:active {
          background-color: @selected;
          color: @background;
        }
    
        progress, progressbar, trough {
          border-radius: 12px;
        }
    
        progressbar {
          background-color: rgba(255, 255, 255, 0.1);
        }
    
        .notification.critical progress {
          background-color: @urgent;
        }
    
        .notification.low progress,
        .notification.normal progress {
          background-color: @selected;
        }
    
        .notification-group {
          margin: 4px 8px;
        }
    
        .notification-group-headers {
          font-size: 1.25rem;
          font-weight: bold;
          color: @text;
          letter-spacing: 2px;
        }
    
        .notification-group-icon {
          color: @text;
        }
    
        .notification-group-collapse-button,
        .notification-group-close-all-button {
          background: transparent;
          color: @text;
          margin: 4px;
          border-radius: 6px;
          padding: 4px;
        }
    
        .notification-group-collapse-button:hover,
        .notification-group-close-all-button:hover {
          background: @hover;
        }
    
        .widget-title {
          font-size: 1.2em;
          margin: 6px;
        }
    
        .widget-title button {
          background: @background-alt;
          border-radius: 6px;
          padding: 4px 16px;
        }
    
        .widget-title button:hover {
          background-color: @hover;
        }
    
        .widget-title button:active {
          background-color: @selected;
        }
    
        .widget-dnd {
          margin: 6px;
          font-size: 1.2rem;
        }
    
        .widget-dnd > switch {
          background: @background-alt;
          font-size: initial;
          border-radius: 8px;
          box-shadow: none;
          padding: 2px;
        }
    
        .widget-dnd > switch:hover {
          background: @hover;
        }
    
        .widget-dnd > switch:checked {
          background: @selected;
        }
    
        .widget-dnd > switch:checked:hover {
          background: @hover;
        }
    
        .widget-dnd > switch slider {
          background: @text;
          border-radius: 6px;
        }
    
        .widget-mpris {
          background: @background-alt;
          border-radius: 16px;
          color: @text;
          margin: 20px 6px;
        }
    
        .widget-mpris-player {
          background-color: rgba(24, 26, 34, 0.7);
          border-radius: 22px;
          padding: 6px 14px;
          margin: 6px;
        }
    
        .widget-mpris-title {
          font-weight: 700;
          font-size: 1rem;
        }
    
        .widget-mpris-subtitle {
          font-weight: 500;
          font-size: 0.8rem;
        }
    
        .widget-mpris-album-art {
          border-radius: 16px;
        }
    
        .widget-mpris > box > button,
        .widget-mpris button {
          color: alpha(@text, 0.6);
          border-radius: 20px;
        }
    
        .widget-mpris button:hover {
          color: @text;
        }
    
        .widget-buttons-grid {
          background: @background-alt;
          font-size: x-large;
          padding: 6px 2px;
          margin: 6px;
          border-radius: 12px;
        }
    
        .widget-buttons-grid>flowbox>flowboxchild>button {
          margin: 4px 10px;
          padding: 6px 12px;
          background: transparent;
          border-radius: 8px;
        }
    
        .widget-buttons-grid>flowbox>flowboxchild>button:hover {
          background: @hover;
        }
    
        .widget-volume {
          background: rgba(32, 36, 44, 0.6);
          color: @background;
          padding: 4px;
          margin: 6px;
          border-radius: 6px;
        }
      '';
    };
  }
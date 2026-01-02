{
  services.swaync = {
    enable = true;
    settings = {
      "\$schema" = "/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      cssPriority = "user";
      
      control-center-width = 420;
      control-center-height = 880;
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 0;
      
      notification-window-width = 420;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      
      timeout = 6;
      timeout-low = 3;
      timeout-critical = 0;
      
      fit-to-screen = false;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
      
      notification-visibility = {
        "spotify" = {
          state = "transient";
          urgency = "Low";
          app-name = "Spotify";
        };
      };
      
      widgets = [
        "label"
        "buttons-grid"
        "mpris"
        "volume"
        "backlight"
        "title"
        "notifications"
      ];
      
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear";
        };
        label = {
          max-lines = 1;
          text = "󱄅  Control Center";
        };
        mpris = {
          image-size = 100;
          image-radius = 16;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = true;
          empty-list-label = "No audio playing";
        };
        backlight = {
          label = " 󰃠";
          device = "intel_backlight";
          min = 1;
        };
        buttons-grid = {
          actions = [
            {
              label = "Mute";
              type = "toggle";
              active = false;
              command = "sh -c '[[ \$SWAYNC_TOGGLE_STATE == true ]] && wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 || wpctl set-mute @DEFAULT_AUDIO_SINK@ 0'";
              update-command = "sh -c '[[ $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED) == 1 ]] && echo true || echo false'";
            }
            {
              label = "WiFi";
              type = "toggle";
              active = true;
              command = "sh -c '[[ \$SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'";
              update-command = "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'";
            }
            {
              label = "BT";
              type = "toggle";
              active = false;
              command = "sh -c '[[ \$SWAYNC_TOGGLE_STATE == true ]] && rfkill unblock bluetooth && sleep 0.5 && bluetoothctl power on || bluetoothctl power off && rfkill block bluetooth'";
              update-command = "sh -c 'bluetoothctl show 2>/dev/null | grep -q \"Powered: yes\" && echo true || echo false'";
            }
            {
              label = "Mic";
              type = "toggle";
              active = true;
              command = "sh -c '[[ \$SWAYNC_TOGGLE_STATE == true ]] && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1'";
              update-command = "sh -c '[[ $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c MUTED) == 0 ]] && echo true || echo false'";
            }
            {
              label = "DND";
              type = "toggle";
              active = false;
              command = "sh -c '[[ \$SWAYNC_TOGGLE_STATE == true ]] && swaync-client -dn || swaync-client -df'";
              update-command = "sh -c 'swaync-client -D && echo true || echo false'";
            }
            {
              label = "Lock";
              command = "hyprlock";
            }
            {
              label = "Settings";
              command = "XDG_CURRENT_DESKTOP=gnome gnome-control-center";
            }
            {
              label = "Picker";
              command = "hyprpicker -a";
            }
            {
              label = "Display";
              command = "nwg-displays";
            }
          ];
        };
      };
    };
    
    style = ''
      /* ╔══════════════════════════════════════════════════════════════════════════════╗
         ║                    CATPPUCCIN MOCHA VIVID SWAYNC                             ║
         ║                   Frosted Glass + Neon Glow Effects v2                       ║
         ╚══════════════════════════════════════════════════════════════════════════════╝ */
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         CATPPUCCIN MOCHA PALETTE
         ═══════════════════════════════════════════════════════════════════════════════ */
      @define-color crust       #11111b;
      @define-color mantle      #181825;
      @define-color base        #1e1e2e;
      @define-color surface0    #313244;
      @define-color surface1    #45475a;
      @define-color surface2    #585b70;
      @define-color overlay0    #6c7086;
      @define-color overlay1    #7f849c;
      @define-color overlay2    #9399b2;
      @define-color subtext0    #a6adc8;
      @define-color subtext1    #bac2de;
      @define-color text        #cdd6f4;
      
      @define-color rosewater   #f5e0dc;
      @define-color flamingo    #f2cdcd;
      @define-color pink        #f5c2e7;
      @define-color mauve       #cba6f7;
      @define-color red         #f38ba8;
      @define-color maroon      #eba0ac;
      @define-color peach       #fab387;
      @define-color yellow      #f9e2af;
      @define-color green       #a6e3a1;
      @define-color teal        #94e2d5;
      @define-color sky         #89dceb;
      @define-color sapphire    #74c7ec;
      @define-color blue        #89b4fa;
      @define-color lavender    #b4befe;
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         GLOBAL RESET
         ═══════════════════════════════════════════════════════════════════════════════ */
      * {
        all: unset;
        font-family: "JetBrains Mono Nerd Font";
        font-size: 14px;
        font-weight: 500;
        color: @text;
        transition: all 250ms cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         BLANK WINDOW
         ═══════════════════════════════════════════════════════════════════════════════ */
      .blank-window {
        background: transparent;
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         CONTROL CENTER
         ═══════════════════════════════════════════════════════════════════════════════ */
      .control-center {
        background: alpha(@crust, 0.85);
        border-radius: 24px;
        border: 2px solid alpha(@lavender, 0.2);
        box-shadow: 
          0 0 0 1px alpha(@blue, 0.15),
          0 20px 60px alpha(black, 0.6),
          0 0 100px alpha(@mauve, 0.12),
          0 0 60px alpha(@blue, 0.08),
          inset 0 1px 0 alpha(white, 0.05);
        margin: 8px;
        padding: 0;
      }
      
      .control-center-list {
        background: transparent;
        padding: 12px;
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         FLOATING NOTIFICATIONS (Pop-ups)
         ═══════════════════════════════════════════════════════════════════════════════ */
      .floating-notifications.background .notification-row .notification-background {
        background: alpha(@crust, 0.9);
        border-radius: 20px;
        border: 2px solid alpha(@lavender, 0.25);
        box-shadow: 
          0 0 0 1px alpha(@blue, 0.2),
          0 12px 40px alpha(black, 0.5),
          0 0 80px alpha(@mauve, 0.15);
        margin: 12px;
      }
      
      .floating-notifications.background .notification-row .notification-background .notification {
        background: transparent;
        padding: 0;
      }
      
      .floating-notifications.background .notification-row .notification-background .notification.low {
        border-left: 4px solid @blue;
        box-shadow: 
          inset 4px 0 20px alpha(@blue, 0.2),
          0 0 40px alpha(@blue, 0.15);
      }
      
      .floating-notifications.background .notification-row .notification-background .notification.normal {
        border-left: 4px solid @lavender;
        box-shadow: 
          inset 4px 0 20px alpha(@lavender, 0.2),
          0 0 40px alpha(@lavender, 0.15);
      }
      
      .floating-notifications.background .notification-row .notification-background .notification.critical {
        border-left: 4px solid @red;
        box-shadow: 
          inset 4px 0 20px alpha(@red, 0.25),
          0 0 50px alpha(@red, 0.25);
        animation: critical-pulse 2s ease-in-out infinite;
      }
      
      @keyframes critical-pulse {
        0%, 100% { box-shadow: inset 4px 0 20px alpha(@red, 0.2), 0 0 40px alpha(@red, 0.2); }
        50% { box-shadow: inset 4px 0 30px alpha(@red, 0.35), 0 0 70px alpha(@red, 0.3); }
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         NOTIFICATION ROW & BACKGROUND (In Control Center)
         ═══════════════════════════════════════════════════════════════════════════════ */
      .notification-row {
        outline: none;
        margin: 0;
        padding: 0;
      }
      
      .notification-background {
        padding: 0;
        margin: 8px 0;
        background: transparent;
        border-radius: 16px;
      }
      
      .notification {
        background: linear-gradient(135deg, alpha(@surface0, 0.7), alpha(@mantle, 0.8));
        border-radius: 16px;
        border: 1px solid alpha(@surface1, 0.5);
        box-shadow: 
          0 4px 16px alpha(black, 0.3),
          0 0 20px alpha(@lavender, 0.05),
          inset 0 1px 0 alpha(white, 0.05);
        padding: 0;
        margin: 0;
      }
      
      .notification:hover {
        background: linear-gradient(135deg, alpha(@surface1, 0.8), alpha(@surface0, 0.9));
        border-color: alpha(@blue, 0.4);
        box-shadow: 
          0 6px 24px alpha(black, 0.4),
          0 0 40px alpha(@blue, 0.15),
          inset 0 1px 0 alpha(white, 0.08);
      }
      
      .notification.low {
        border-left: 3px solid @sapphire;
        box-shadow: 
          0 4px 16px alpha(black, 0.3),
          0 0 25px alpha(@sapphire, 0.1);
      }
      
      .notification.low:hover {
        box-shadow: 
          0 6px 24px alpha(black, 0.4),
          0 0 40px alpha(@sapphire, 0.2);
      }
      
      .notification.normal {
        border-left: 3px solid @lavender;
        box-shadow: 
          0 4px 16px alpha(black, 0.3),
          0 0 25px alpha(@lavender, 0.1);
      }
      
      .notification.normal:hover {
        box-shadow: 
          0 6px 24px alpha(black, 0.4),
          0 0 40px alpha(@lavender, 0.2);
      }
      
      .notification.critical {
        border-left: 3px solid @red;
        border: 2px solid alpha(@red, 0.4);
        background: linear-gradient(135deg, alpha(@red, 0.12), alpha(@surface0, 0.8));
        animation: critical-glow 2s ease-in-out infinite;
      }
      
      @keyframes critical-glow {
        0%, 100% { 
          box-shadow: 0 4px 16px alpha(black, 0.3), 0 0 30px alpha(@red, 0.25);
        }
        50% { 
          box-shadow: 0 4px 20px alpha(black, 0.4), 0 0 50px alpha(@red, 0.35);
        }
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         NOTIFICATION CONTENT
         ═══════════════════════════════════════════════════════════════════════════════ */
      .notification-content {
        padding: 14px 16px;
      }
      
      .notification-default-action {
        border-radius: 16px;
        padding: 0;
      }
      
      .notification-default-action:hover {
        background: transparent;
      }
      
      .image {
        border-radius: 12px;
        margin-right: 14px;
        box-shadow: 
          0 4px 12px alpha(black, 0.4),
          0 0 20px alpha(@lavender, 0.1);
        border: 2px solid alpha(@surface1, 0.5);
      }
      
      .app-icon {
        border-radius: 10px;
        margin-right: 12px;
      }
      
      .summary {
        font-size: 15px;
        font-weight: 700;
        color: @text;
        text-shadow: 0 1px 2px alpha(black, 0.3);
      }
      
      .body {
        font-size: 13px;
        font-weight: 400;
        color: @subtext1;
        margin-top: 4px;
      }
      
      .time {
        font-size: 11px;
        font-weight: 500;
        color: @overlay1;
        margin-top: 6px;
      }
      
      .notification > *:last-child > * {
        min-height: 3.4em;
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         NOTIFICATION ACTIONS
         ═══════════════════════════════════════════════════════════════════════════════ */
      .notification-action {
        background: linear-gradient(135deg, alpha(@blue, 0.18), alpha(@lavender, 0.12));
        border-radius: 12px;
        border: 1px solid alpha(@blue, 0.25);
        margin: 6px;
        padding: 8px 16px;
        color: @blue;
        font-weight: 600;
        font-size: 13px;
      }
      
      .notification-action:hover {
        background: linear-gradient(135deg, alpha(@blue, 0.4), alpha(@lavender, 0.35));
        border-color: @blue;
        color: @text;
        box-shadow: 0 0 25px alpha(@blue, 0.35);
      }
      
      .notification-action:active {
        background: linear-gradient(135deg, alpha(@blue, 0.55), alpha(@lavender, 0.5));
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         CLOSE BUTTON
         ═══════════════════════════════════════════════════════════════════════════════ */
      .close-button {
        background: linear-gradient(135deg, alpha(@red, 0.18), alpha(@maroon, 0.12));
        border-radius: 50%;
        min-width: 28px;
        min-height: 28px;
        margin: 8px;
        border: 1px solid alpha(@red, 0.35);
        color: @red;
      }
      
      .close-button:hover {
        background: linear-gradient(135deg, alpha(@red, 0.45), alpha(@peach, 0.4));
        color: @text;
        box-shadow: 0 0 25px alpha(@red, 0.45);
        border-color: @red;
      }
      
      .close-button:active {
        background: linear-gradient(135deg, alpha(@red, 0.65), alpha(@peach, 0.55));
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         PROGRESS BAR (in notifications)
         ═══════════════════════════════════════════════════════════════════════════════ */
      .notification progressbar,
      .notification progress,
      .notification trough {
        border-radius: 99px;
        min-height: 8px;
      }
      
      .notification trough {
        background: alpha(@surface0, 0.6);
        min-height: 8px;
        border: 1px solid alpha(@surface1, 0.3);
      }
      
      .notification progress {
        min-height: 6px;
        margin: 1px;
      }
      
      .notification.low progress {
        background: linear-gradient(90deg, @sapphire, @sky);
        box-shadow: 0 0 12px alpha(@sapphire, 0.6);
      }
      
      .notification.normal progress {
        background: linear-gradient(90deg, @blue, @lavender, @mauve);
        box-shadow: 0 0 12px alpha(@lavender, 0.6);
      }
      
      .notification.critical progress {
        background: linear-gradient(90deg, @red, @peach);
        box-shadow: 0 0 12px alpha(@red, 0.6);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         NOTIFICATION GROUPS
         ═══════════════════════════════════════════════════════════════════════════════ */
      .notification-group {
        margin: 8px 4px;
      }
      
      .notification-group-headers {
        font-size: 13px;
        font-weight: 700;
        color: @mauve;
        letter-spacing: 1px;
        text-transform: uppercase;
        padding: 8px 12px;
        text-shadow: 0 0 15px alpha(@mauve, 0.5);
      }
      
      .notification-group-icon {
        color: @mauve;
        margin-right: 8px;
      }
      
      .notification-group-collapse-button,
      .notification-group-close-all-button {
        background: alpha(@surface0, 0.5);
        color: @text;
        margin: 4px;
        border-radius: 10px;
        padding: 6px 10px;
        border: 1px solid transparent;
      }
      
      .notification-group-collapse-button:hover,
      .notification-group-close-all-button:hover {
        background: alpha(@mauve, 0.25);
        color: @mauve;
        border-color: alpha(@mauve, 0.4);
        box-shadow: 0 0 20px alpha(@mauve, 0.2);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: LABEL (Header with NixOS icon)
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-label {
        background: linear-gradient(135deg, alpha(@sapphire, 0.15), alpha(@blue, 0.1));
        border-radius: 16px;
        margin: 8px 12px 16px 12px;
        padding: 16px 20px;
        border: 1px solid alpha(@sapphire, 0.25);
        box-shadow: 
          0 4px 16px alpha(black, 0.2),
          0 0 40px alpha(@sapphire, 0.1),
          inset 0 1px 0 alpha(white, 0.05);
      }
      
      .widget-label > label {
        font-size: 18px;
        font-weight: 700;
        color: @sapphire;
        letter-spacing: 1px;
        text-shadow: 0 0 25px alpha(@sapphire, 0.6);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: TITLE
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-title {
        background: alpha(@surface0, 0.4);
        border-radius: 14px;
        margin: 8px 12px;
        padding: 12px 16px;
        border: 1px solid alpha(@surface1, 0.3);
      }
      
      .widget-title > label {
        font-size: 15px;
        font-weight: 700;
        color: @text;
      }
      
      .widget-title button {
        background: linear-gradient(135deg, alpha(@red, 0.18), alpha(@maroon, 0.12));
        border-radius: 10px;
        padding: 8px 16px;
        border: 1px solid alpha(@red, 0.25);
        color: @red;
        font-weight: 600;
        margin-left: auto;
      }
      
      .widget-title button:hover {
        background: linear-gradient(135deg, alpha(@red, 0.4), alpha(@peach, 0.35));
        color: @text;
        border-color: @red;
        box-shadow: 0 0 25px alpha(@red, 0.35);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: MPRIS
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-mpris {
        background: linear-gradient(135deg, alpha(@mauve, 0.12), alpha(@pink, 0.1));
        border-radius: 20px;
        margin: 12px;
        padding: 4px;
        border: 1px solid alpha(@mauve, 0.25);
        box-shadow: 
          0 8px 24px alpha(black, 0.3),
          0 0 50px alpha(@mauve, 0.12);
      }
      
      .widget-mpris-player {
        background: linear-gradient(135deg, alpha(@surface0, 0.6), alpha(@mantle, 0.8));
        border-radius: 16px;
        padding: 12px 16px;
        margin: 4px;
      }
      
      .widget-mpris-album-art {
        border-radius: 14px;
        box-shadow: 
          0 8px 20px alpha(black, 0.5),
          0 0 40px alpha(@mauve, 0.25);
        border: 2px solid alpha(@surface1, 0.5);
      }
      
      .widget-mpris-title {
        font-weight: 700;
        font-size: 15px;
        color: @text;
        text-shadow: 0 1px 3px alpha(black, 0.3);
      }
      
      .widget-mpris-subtitle {
        font-weight: 500;
        font-size: 13px;
        color: @subtext0;
        margin-top: 2px;
      }
      
      .widget-mpris > box > button {
        background: alpha(@surface0, 0.5);
        border-radius: 50%;
        min-width: 40px;
        min-height: 40px;
        color: @overlay2;
        border: 1px solid alpha(@surface1, 0.5);
      }
      
      .widget-mpris > box > button:hover {
        background: linear-gradient(135deg, alpha(@mauve, 0.45), alpha(@pink, 0.4));
        color: @text;
        border-color: @mauve;
        box-shadow: 0 0 30px alpha(@mauve, 0.5);
      }
      
      .widget-mpris > box > button:active {
        background: linear-gradient(135deg, alpha(@mauve, 0.65), alpha(@pink, 0.55));
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: VOLUME
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-volume {
        background: linear-gradient(135deg, alpha(@pink, 0.12), alpha(@mauve, 0.1));
        border-radius: 16px;
        margin: 8px 12px;
        padding: 14px 18px;
        border: 1px solid alpha(@pink, 0.25);
        box-shadow: 0 0 30px alpha(@pink, 0.08);
      }
      
      .widget-volume > box > label {
        color: @pink;
        font-size: 22px;
        font-weight: 600;
        min-width: 28px;
        margin-right: 12px;
        text-shadow: 0 0 15px alpha(@pink, 0.5);
      }
      
      .widget-volume > box > button {
        background: alpha(@surface0, 0.5);
        border-radius: 10px;
        padding: 8px 12px;
        color: @pink;
        border: 1px solid alpha(@pink, 0.25);
        min-width: 36px;
        margin-left: 8px;
      }
      
      .widget-volume > box > button:hover {
        background: linear-gradient(135deg, alpha(@pink, 0.4), alpha(@mauve, 0.35));
        color: @text;
        border-color: @pink;
        box-shadow: 0 0 25px alpha(@pink, 0.4);
      }
      
      .widget-volume scale {
        padding: 0 4px;
      }
      
      .widget-volume trough {
        background: alpha(@surface0, 0.6);
        min-height: 10px;
        border-radius: 99px;
        border: 1px solid alpha(@surface1, 0.3);
      }
      
      .widget-volume highlight {
        background: linear-gradient(90deg, @pink, @mauve);
        border-radius: 99px;
        box-shadow: 0 0 12px alpha(@pink, 0.5);
      }
      
      .widget-volume slider {
        background: radial-gradient(circle, @text 0%, @subtext1 100%);
        border-radius: 50%;
        min-width: 18px;
        min-height: 18px;
        margin: -4px;
        box-shadow: 
          0 2px 6px alpha(black, 0.5),
          0 0 10px alpha(@pink, 0.3);
      }
      
      .per-app-volume {
        background: alpha(@surface0, 0.35);
        border-radius: 12px;
        padding: 10px 12px;
        margin: 8px 0;
        border: 1px solid alpha(@surface1, 0.2);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: BACKLIGHT (Matched to Volume)
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-backlight {
        background: linear-gradient(135deg, alpha(@yellow, 0.14), alpha(@peach, 0.1));
        border-radius: 16px;
        margin: 8px 12px;
        padding: 14px 18px;
        border: 1px solid alpha(@yellow, 0.25);
        box-shadow: 0 0 30px alpha(@yellow, 0.08);
      }
      
      .widget-backlight > box > label {
        color: @yellow;
        font-size: 22px;
        font-weight: 600;
        min-width: 28px;
        margin-right: 12px;
        text-shadow: 0 0 15px alpha(@yellow, 0.5);
      }
      
      /* Match volume button spacing - add invisible placeholder for alignment */
      .widget-backlight > box > button {
        background: alpha(@surface0, 0.5);
        border-radius: 10px;
        padding: 8px 12px;
        color: @yellow;
        border: 1px solid alpha(@yellow, 0.25);
        min-width: 36px;
        margin-left: 8px;
      }
      
      .widget-backlight > box > button:hover {
        background: linear-gradient(135deg, alpha(@yellow, 0.4), alpha(@peach, 0.35));
        color: @text;
        border-color: @yellow;
        box-shadow: 0 0 25px alpha(@yellow, 0.4);
      }
      
      .widget-backlight scale {
        padding: 0 28px;
      }
      
      .widget-backlight trough {
        background: alpha(@surface0, 0.6);
        min-height: 10px;
        border-radius: 99px;
        border: 1px solid alpha(@surface1, 0.3);
      }
      
      .widget-backlight highlight {
        background: linear-gradient(90deg, @yellow, @peach);
        border-radius: 99px;
        box-shadow: 0 0 12px alpha(@yellow, 0.5);
      }
      
      .widget-backlight slider {
        background: radial-gradient(circle, @text 0%, @subtext1 100%);
        border-radius: 50%;
        min-width: 18px;
        min-height: 18px;
        margin: -4px;
        box-shadow: 
          0 2px 6px alpha(black, 0.5),
          0 0 10px alpha(@yellow, 0.3);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         WIDGET: BUTTONS GRID
         ═══════════════════════════════════════════════════════════════════════════════ */
      .widget-buttons-grid {
        background: alpha(@surface0, 0.35);
        border-radius: 18px;
        padding: 12px 8px;
        margin: 8px 12px;
        border: 1px solid alpha(@surface1, 0.35);
        box-shadow: 0 0 25px alpha(@lavender, 0.05);
      }
      
      .widget-buttons-grid > flowbox {
        padding: 4px;
      }
      
      .widget-buttons-grid > flowbox > flowboxchild {
        padding: 4px;
      }
      
      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: linear-gradient(135deg, alpha(@surface1, 0.6), alpha(@surface0, 0.8));
        border-radius: 16px;
        min-width: 70px;
        min-height: 50px;
        padding: 8px 12px;
        border: 2px solid alpha(@surface2, 0.35);
        color: @subtext1;
        font-size: 13px;
        font-weight: 600;
        box-shadow: 
          0 4px 12px alpha(black, 0.2),
          inset 0 1px 0 alpha(white, 0.05);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background: linear-gradient(135deg, alpha(@blue, 0.28), alpha(@lavender, 0.22));
        border-color: alpha(@blue, 0.5);
        color: @text;
        box-shadow: 
          0 6px 20px alpha(black, 0.3),
          0 0 35px alpha(@blue, 0.2);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@blue, 0.35), alpha(@lavender, 0.3));
        border-color: @blue;
        color: @text;
        box-shadow: 
          0 6px 20px alpha(black, 0.3),
          0 0 40px alpha(@blue, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked:hover {
        background: linear-gradient(135deg, alpha(@sapphire, 0.4), alpha(@blue, 0.35));
        box-shadow: 
          0 6px 24px alpha(black, 0.4),
          0 0 45px alpha(@blue, 0.35);
      }
      
      /* Button-specific colors */
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(1) > button:hover,
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(1) > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@red, 0.3), alpha(@maroon, 0.25));
        border-color: @red;
        color: @text;
        box-shadow: 0 0 35px alpha(@red, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(2) > button:hover,
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(2) > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@sky, 0.3), alpha(@sapphire, 0.25));
        border-color: @sky;
        color: @text;
        box-shadow: 0 0 35px alpha(@sky, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(3) > button:hover,
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(3) > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@blue, 0.3), alpha(@lavender, 0.25));
        border-color: @blue;
        color: @text;
        box-shadow: 0 0 35px alpha(@blue, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(4) > button:hover,
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(4) > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@teal, 0.3), alpha(@green, 0.25));
        border-color: @teal;
        color: @text;
        box-shadow: 0 0 35px alpha(@teal, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(5) > button:hover,
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(5) > button.toggle:checked {
        background: linear-gradient(135deg, alpha(@maroon, 0.3), alpha(@red, 0.25));
        border-color: @maroon;
        color: @text;
        box-shadow: 0 0 35px alpha(@maroon, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(6) > button:hover {
        background: linear-gradient(135deg, alpha(@yellow, 0.3), alpha(@peach, 0.25));
        border-color: @yellow;
        color: @text;
        box-shadow: 0 0 35px alpha(@yellow, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(7) > button:hover {
        background: linear-gradient(135deg, alpha(@mauve, 0.3), alpha(@pink, 0.25));
        border-color: @mauve;
        color: @text;
        box-shadow: 0 0 35px alpha(@mauve, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(8) > button:hover {
        background: linear-gradient(135deg, alpha(@flamingo, 0.3), alpha(@rosewater, 0.25));
        border-color: @flamingo;
        color: @text;
        box-shadow: 0 0 35px alpha(@flamingo, 0.3);
      }
      
      .widget-buttons-grid > flowbox > flowboxchild:nth-child(9) > button:hover {
        background: linear-gradient(135deg, alpha(@sapphire, 0.3), alpha(@sky, 0.25));
        border-color: @sapphire;
        color: @text;
        box-shadow: 0 0 35px alpha(@sapphire, 0.3);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         SCROLLBAR
         ═══════════════════════════════════════════════════════════════════════════════ */
      scrollbar {
        background: transparent;
        border-radius: 99px;
      }
      
      scrollbar slider {
        background: alpha(@surface2, 0.6);
        border-radius: 99px;
        min-width: 8px;
        min-height: 40px;
      }
      
      scrollbar slider:hover {
        background: alpha(@lavender, 0.6);
        box-shadow: 0 0 15px alpha(@lavender, 0.4);
      }
      
      /* ═══════════════════════════════════════════════════════════════════════════════
         TOOLTIP
         ═══════════════════════════════════════════════════════════════════════════════ */
      tooltip {
        background: alpha(@crust, 0.95);
        border-radius: 12px;
        border: 1px solid alpha(@lavender, 0.25);
        box-shadow: 
          0 8px 24px alpha(black, 0.5),
          0 0 30px alpha(@lavender, 0.1);
      }
      
      tooltip label {
        color: @text;
        padding: 8px 12px;
        font-size: 13px;
      }
    '';
  };
}
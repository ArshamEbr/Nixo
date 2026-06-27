{ # It just works™ keybinds by Celes Renata (Modified by ArshamEbr xD)
  wayland.windowManager.hyprland.settings = {
    "$Alternate" = "ALT";
    "$MenuButton" = "MENU";
    "$Primary" = "SUPER";
    "$Secondary" = "CONTROL";
    "$Tertiary" = "SHIFT";
  
    bind = [
    #  "$Primary, A, exec, pkill anyrun || anyrun"
    #  "$Primary, TAB, hyprexpo:expo, toggle"
      "$Primary, A, exec, pkill wofi || wofi"
      # "$Primary, A, exec, rofi -show drun"
      "$Primary$Alternate, Q, exec, pkill wlogout || wlogout -p layer-shell"
      "$Primary$Secondary, K, exec, wallch --chgw"
      "$Primary$Alternate, p, exec, dgpu_windows_vm_start"
      "$Primary$Alternate, o, exec, dgpu_windows_vm_shutdown"
      "$Primary$Alternate, i, exec, iaudio_dgpu_windows_vm_start"
      "$Primary$Alternate, 0, exec, battery_toggle"
      "$Primary$Alternate, 9, exec, tlp_mode"
      "$Primary$Alternate, 7, exec, check_gpu_status"
      "$Primary$Alternate, 8, exec, power-save"
      "$Primary, 1, exec, vesktop"
      "$Alternate, 1, exec, discord"
      "$Primary, 2, exec, Telegram"
      "$Primary, M, exec, [float; size 50% 56%; move 100%-w-15 66] foot -e btop"
      "$Alternate, M, exec, [float; size 50% 55%; move 100%-w-15 66] kitty -e btop"
      "$Primary$Alternate, M, exec, missioncenter"
      "$Primary, T, exec, foot"
      "$Alternate, T, exec, kitty"
      "$Primary$Secondary, T, exec, kitty -e nmtui"
      "$Primary, E, exec, nautilus"
      "$Alternate, E, exec, thunar"
      "$Alternate, B, exec, firefox"
    #  "$Primary, B, exec, zen"
      "$Primary, B, exec, brave"
      "$Primary$Secondary, X, exec, subl"
      "$Primary, C, exec, code"
      ",XF86Calculator, exec, wofi-calc"
      "$Primary$Secondary, I, exec, XDG_CURRENT_DESKTOP='gnome' gnome-control-center"
      "$Primary$Secondary, V, exec, "
      "$Primary$Tertiary, Home, exec, gnome-system-monitor"
      "$Primary$Secondary, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji"
      "$Secondary$Alternate, Space, togglefloating,"
      "$Primary, Q, killactive,"
      "$Primary$Tertiary, Q, exec, hyprctl kill"
      "$Primary$Tertiary$Alternate$Secondary, Delete, exec, systemctl poweroff"
      "$Secondary$Tertiary, D, exec,~/.local/bin/rubyshot | wl-copy"
      "$Secondary$Tertiary, 4, exec, grim -g \"$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" - | wl-copy"
      "$Secondary$Tertiary, 5, exec, record-script"
      "$Secondary$Alternate, 5, exec, record-script --sound"
      "$Secondary$Tertiary$Alternate, 5, exec, record-script --fullscreen-sound"
      "$Secondary$Alternate, C, exec, hyprpicker -a"
      "$Primary$Alternate, Space, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl"
      "$Primary, V, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl"
      "$Primary$Secondary$Tertiary,S,exec,grim -g \"$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" 'tmp.png' && tesseract 'tmp.png' - | wl-copy && rm 'tmp.png'"
      # "$Secondary$Tertiary, B, exec, playerctl previous"
      # "$Secondary$Tertiary, P, exec, playerctl play-pause"
      "$Secondary$Tertiary, T, exec, waypaper"
      "$Secondary$Tertiary, left, movewindow, l"
      "$Secondary$Tertiary, right, movewindow, r"
      "$Secondary$Tertiary, up, movewindow, u"
      "$Secondary$Tertiary, down, movewindow, d"
      "$Secondary, left, movefocus, l"
      "$Secondary, right, movefocus, r"
      "$Alternate, up, movefocus, u"
      "$Alternate, down, movefocus, d"
      "$Secondary, BracketLeft, movefocus, l"
      "$Secondary, BracketRight, movefocus, r"

      "$Tertiary, right, workspace, +1"
      "$Tertiary, left, workspace, -1"
      "$Primary$Secondary, BracketLeft, workspace, -1"
      "$Primary$Secondary, BracketRight, workspace, +1"
      "$Primary$Secondary, up, workspace, -5"
      "$Primary$Secondary, down, workspace, +5"
      "$Secondary, Page_Down, workspace, +1"
      "$Secondary, Page_Up, workspace, -1"
      "$Primary$Secondary, Page_Down, workspace, +1"
      "$Primary$Secondary, Page_Up, workspace, -1"

      "$Secondary$Alternate, Page_Down, movetoworkspace, +1"
      "$Secondary$Alternate, Page_Up, movetoworkspace, -1"
      "$Secondary$Tertiary, Page_Down, movetoworkspace, +1"
      "$Secondary$Tertiary, Page_Up, movetoworkspace, -1"
      "$Primary$Secondary$Tertiary, Right, movetoworkspace, +1"
      "$Primary$Secondary$Tertiary, Left, movetoworkspace, -1"
      "$Secondary$Tertiary, mouse_down, movetoworkspace, -1"
      "$Secondary$Tertiary, mouse_up, movetoworkspace, +1"
      "$Secondary$Alternate, mouse_down, movetoworkspace, -1"
      "$Secondary$Alternate, mouse_up, movetoworkspace, +1"
      "$Primary$Secondary, F, fullscreen, 0"
      "$Primary$Secondary, D, fullscreen, 1"
      "$Secondary, 1, workspace, 1"
      "$Secondary, 2, workspace, 2"
      "$Secondary, 3, workspace, 3"
      "$Secondary, 4, workspace, 4"
      "$Secondary, 5, workspace, 5"
      "$Secondary, 6, workspace, 6"
      "$Secondary, 7, workspace, 7"
      "$Secondary, 8, workspace, 8"
      "$Secondary, 9, workspace, 9"
      "$Secondary, 0, workspace, 10"
      "$Primary$Secondary, S, togglespecialworkspace,"
      "$Alternate, Tab, cyclenext"
      "$Alternate, Tab, bringactivetotop,"
      "$Secondary $Alternate, 1, movetoworkspacesilent, 1"
      "$Secondary $Alternate, 2, movetoworkspacesilent, 2"
      "$Secondary $Alternate, 3, movetoworkspacesilent, 3"
      "$Secondary $Alternate, 4, movetoworkspacesilent, 4"
      "$Secondary $Alternate, 5, movetoworkspacesilent, 5"
      "$Secondary $Alternate, 6, movetoworkspacesilent, 6"
      "$Secondary $Alternate, 7, movetoworkspacesilent, 7"
      "$Secondary $Alternate, 8, movetoworkspacesilent, 8"
      "$Secondary $Alternate, 9, movetoworkspacesilent, 9"
      "$Secondary $Alternate, 0, movetoworkspacesilent, 10"
      "$Primary$Tertiary$Secondary, Up, movetoworkspacesilent, special"
      "$Secondary$Alternate, S, movetoworkspacesilent, special"
      "$Secondary, mouse_up, workspace, +1"
      "$Secondary, mouse_down, workspace, -1"
      "$Primary$Secondary, mouse_up, workspace, +1"
      "$Primary$Secondary, mouse_down, workspace, -1"
      "Primary$Secondary, Backslash, resizeactive, exact 640 480"
      "Secondary$Alternate, J, exec, ydotool key 105:1 105:0"
    ];
  
    # Split ratio adjustments
    binde = [
      "$Primary$Secondary, Minus, splitratio, -0.1"
      "$Primary$Secondary, Equal, splitratio, 0.1"
      "$Secondary, Semicolon, splitratio, -0.1"
      "$Secondary, Apostrophe, splitratio, 0.1"
    ];
  
    # Clipboard & Print
    bindl = [
      ",Print,exec,grim - | wl-copy"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioPlay, exec, playerctl play-pause"
      "$Secondary$Tertiary, L, exec, sleep 0.1 && systemctl suspend"
      "$Primary$Secondary, L, exec, hyprlock"
    ];
  
    # Volume & Brightness with notifications
    bindle = [
      ", XF86AudioRaiseVolume, exec, sh -c \"wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-high-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000\""
      ", XF86AudioLowerVolume, exec, sh -c \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-low-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000\""
      ", XF86MonBrightnessUp, exec, bash -c 'brightnessctl set 5%+ && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-high-symbolic \"󰃠 Brightness\" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'"
      ", XF86MonBrightnessDown, exec, bash -c 'brightnessctl set 5%- && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-low-symbolic \"󰃠 Brightness\" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'"
      ", XF86AudioMute, exec, sh -c \"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($2==0) ? \"audio-volume-muted-symbolic\" : \"audio-volume-high-symbolic\"}') '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000\""
    ];

  
    # Mouse binds
    bindm = [
      "$Primary, mouse:273, resizewindow"
      "$Primary$Secondary, mouse:273, resizewindow"
      ",mouse:274, movewindow"
      "$Secondary, mouse:273, movewindow"
      "$Primary$Secondary, Z, movewindow"
    ];
  
    # Reload config and components
    bindr = [
      "$Primary$Secondary, R, exec, hyprctl reload; pkill waybar; pkill activewin.sh; pkill activews.sh; pkill gohypr; pkill bash; pkill ydotool; waybar &"
    ];
  };
}
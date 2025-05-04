{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/keybinds.conf".text = ''
        ################### It just works™ keybinds by Celes Renata (Modified by ArshamEbr xD) ###################

        # $Secondary is a reference to Command or Win, depending on what is plugged into the computer.

        $Alternate=ALT
        $MenuButton=MENU
        $Primary=SUPER
        $Secondary=CONTROL
        $Tertiary=SHIFT
        
        bind = $Primary, A, exec, pkill anyrun || anyrun
      #  bind = $Primary, A, exec, rofi -show drun
        bind = $Primary$Alternate, Q, exec, pkill wlogout || wlogout -p layer-shell

        bind = $Primary$Secondary, K, exec, wallch --chgw

        bind = $Primary$Alternate, p, exec, dgpu_windows_vm_start
        bind = $Primary$Alternate, o, exec, dgpu_windows_vm_shutdown
        bind = $Primary$Alternate, i, exec, iaudio_dgpu_windows_vm_start

        bind = $Primary$Alternate, 0, exec, battery_toggle
        bind = $Primary$Alternate, 9, exec, tlp_mode
        bind = $Primary$Alternate, 8, exec, check_gpu_status

        bind = $Primary, 1, exec, vesktop
        bind = $Alternate, 1, exec, discord
        bind = $Primary, 2, exec, telegram-desktop

        bind = $Primary, M, exec, [float; size 50% 56%; move 100%-w-10 43] foot -e btop
        bind = $Alternate, M, exec, [float; size 50% 55%; move 100%-w-10 43] kitty -e btop
        bind = $Primary$Alternate, M, exec, missioncenter

        bind = $Primary, T, exec, foot
        bind = $Alternate, T, exec, kitty

        bind = $Primary$Secondary, T, exec, kitty -e nmtui

        bind = $Primary, E, exec, nautilus
        bind = $Alternate, E, exec, thunar

        bind = $Primary, B, exec, brave
        bind = $Alternate, B, exec, zen

        bind = $Primary$Secondary, X, exec, subl
        bind = $Primary, C, exec, code

        bind = ,XF86Calculator, exec, ~/.local/bin/wofi-calc
        
        bind = $Primary$Secondary, I, exec, XDG_CURRENT_DESKTOP='gnome' gnome-control-center
        bind = $Primary$Secondary, V, exec, 
        bind = $Primary$Tertiary, Home, exec, gnome-system-monitor
        bind = $Primary$Secondary, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji
        bind = $Alternate, F4, killactive,
        bind = $Secondary$Alternate, Space, togglefloating,
        bind = $Primary, Q, exec, hyprctl kill
        bind = $Primary$Tertiary$Alternate$Secondary, Delete, exec, systemctl poweroff
        bind = $Secondary$Tertiary, D, exec,~/.local/bin/rubyshot | wl-copy
        bind = $Secondary$Tertiary, 4, exec, grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" - | wl-copy
        bind = $Secondary$Tertiary, 5, exec, record-script
        bind = $Secondary$Alternate, 5, exec, record-script --sound
        bind = $Secondary$Tertiary$Alternate, 5, exec, record-script --fullscreen-sound
        bind = $Secondary$Alternate, C, exec, hyprpicker -a
        bind = $Primary$Alternate, Space, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl
        bind = $Secondary$Alternate, V, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl
        bind = $Primary$Secondary$Tertiary,S,exec,grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" 'tmp.png' && tesseract 'tmp.png' - | wl-copy && rm 'tmp.png'
      #  bind = $Secondary$Tertiary, B, exec, playerctl previous
      #  bind = $Secondary$Tertiary, P, exec, playerctl play-pause
        
      #  bind = $Secondary$Tertiary, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh
        bind = $Secondary$Tertiary, T, exec, waypaper
        
        bind = $Secondary$Tertiary, left, movewindow, l
        bind = $Secondary$Tertiary, right, movewindow, r
        bind = $Secondary$Tertiary, up, movewindow, u
        bind = $Secondary$Tertiary, down, movewindow, d
        bind = $Secondary, left, movefocus, l
        bind = $Secondary, right, movefocus, r
        bind = $Alternate, up, movefocus, u
        bind = $Alternate, down, movefocus, d
        bind = $Secondary, BracketLeft, movefocus, l
        bind = $Secondary, BracketRight, movefocus, r
        bind = $Primary$Secondary, right, workspace, +1
        bind = $Primary$Secondary, left, workspace, -1
        bind = $Primary$Secondary, BracketLeft, workspace, -1
        bind = $Primary$Secondary, BracketRight, workspace, +1
        bind = $Primary$Secondary, up, workspace, -5
        bind = $Primary$Secondary, down, workspace, +5
        bind = $Secondary, Page_Down, workspace, +1
        bind = $Secondary, Page_Up, workspace, -1
        bind = $Primary$Secondary, Page_Down, workspace, +1
        bind = $Primary$Secondary, Page_Up, workspace, -1
        bind = $Secondary$Alternate, Page_Down, movetoworkspace, +1
        bind = $Secondary$Alternate, Page_Up, movetoworkspace, -1
        bind = $Secondary$Tertiary, Page_Down, movetoworkspace, +1
        bind = $Secondary$Tertiary, Page_Up, movetoworkspace, -1
        bind = $Primary$Secondary$Tertiary, Right, movetoworkspace, +1
        bind = $Primary$Secondary$Tertiary, Left, movetoworkspace, -1
        bind = $Secondary$Tertiary, mouse_down, movetoworkspace, -1
        bind = $Secondary$Tertiary, mouse_up, movetoworkspace, +1
        bind = $Secondary$Alternate, mouse_down, movetoworkspace, -1
        bind = $Secondary$Alternate, mouse_up, movetoworkspace, +1
        bind = $Primary$Secondary, F, fullscreen, 0
        bind = $Primary$Secondary, D, fullscreen, 1
        bind = $Secondary, 1, workspace, 1
        bind = $Secondary, 2, workspace, 2
        bind = $Secondary, 3, workspace, 3
        bind = $Secondary, 4, workspace, 4
        bind = $Secondary, 5, workspace, 5
        bind = $Secondary, 6, workspace, 6
        bind = $Secondary, 7, workspace, 7
        bind = $Secondary, 8, workspace, 8
        bind = $Secondary, 9, workspace, 9
        bind = $Secondary, 0, workspace, 10
        bind = $Primary$Secondary, S, togglespecialworkspace,
        bind = $Alternate, Tab, cyclenext
        bind = $Alternate, Tab, bringactivetotop,
        bind = $Secondary $Alternate, 1, movetoworkspacesilent, 1
        bind = $Secondary $Alternate, 2, movetoworkspacesilent, 2
        bind = $Secondary $Alternate, 3, movetoworkspacesilent, 3
        bind = $Secondary $Alternate, 4, movetoworkspacesilent, 4
        bind = $Secondary $Alternate, 5, movetoworkspacesilent, 5
        bind = $Secondary $Alternate, 6, movetoworkspacesilent, 6
        bind = $Secondary $Alternate, 7, movetoworkspacesilent, 7
        bind = $Secondary $Alternate, 8, movetoworkspacesilent, 8
        bind = $Secondary $Alternate, 9, movetoworkspacesilent, 9
        bind = $Secondary $Alternate, 0, movetoworkspacesilent, 10
        bind = $Primary$Tertiary$Secondary, Up, movetoworkspacesilent, special
        bind = $Secondary$Alternate, S, movetoworkspacesilent, special
        bind = $Secondary, mouse_up, workspace, +1
        bind = $Secondary, mouse_down, workspace, -1
        bind = $Primary$Secondary, mouse_up, workspace, +1
        bind = $Primary$Secondary, mouse_down, workspace, -1
        bind = Primary$Secondary, Backslash, resizeactive, exact 640 480
        bind = Secondary$Alternate, J, exec, ydotool key 105:1 105:0 
            
        binde = $Primary$Secondary, Minus, splitratio, -0.1
        binde = $Primary$Secondary, Equal, splitratio, 0.1
        binde = $Secondary, Semicolon, splitratio, -0.1
        binde = $Secondary, Apostrophe, splitratio, 0.1
        
        # Clipboard
        bindl = ,Print,exec,grim - | wl-copy

        # Media Control
        bindl = , XF86AudioNext, exec, playerctl next
        bindl = , XF86AudioPrev, exec, playerctl previous
        bindl = , XF86AudioPlay, exec, playerctl play-pause

        # Lock & Suspend
        bindl = $Secondary$Tertiary, L, exec, sleep 0.1 && systemctl suspend
        bind = $Primary$Secondary, L, exec, hyprlock
        
        # Volume & Brightness
        bindle = , XF86AudioRaiseVolume, exec, sh -c "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-high-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        bindle = , XF86AudioLowerVolume, exec, sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-low-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        bindl = , XF86AudioMute, exec, sh -c "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($2==0) ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic"}') '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        bindle = , XF86MonBrightnessUp, exec, bash -c 'brightnessctl set 5%+ && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-high-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
        bindle = , XF86MonBrightnessDown, exec, bash -c 'brightnessctl set 5%- && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-low-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
        
        # Move/resize windows with $Secondary + LMB/RMB and dragging
        bindm = $Primary, mouse:273, resizewindow
        bindm = $Primary$Secondary, mouse:273, resizewindow
        bindm = ,mouse:274, movewindow
        bindm = $Secondary, mouse:273, movewindow
        bindm = $Primary$Secondary, Z, movewindow
        
        # Restart Waybar
        bindr = $Primary$Secondary, R, exec, hyprctl reload; pkill waybar; pkill activewin.sh; pkill activews.sh; pkill gohypr; pkill bash; pkill ydotool; waybar &

      '';
      };
    };
  }

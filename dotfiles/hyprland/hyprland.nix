{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/hyprland.conf".text = ''
      exec-once = /nix/store/qkj4b3si2xbry58xslhm1vrixhxrvskp-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
      $Alternate=ALT
      $MenuButton=MENU
      $Primary=SUPER
      $Secondary=CONTROL
      $Tertiary=SHIFT
      animations {
        bezier=linear, 0, 0, 1, 1
        bezier=md3_standard, 0.2, 0, 0, 1
        bezier=md3_decel, 0.05, 0.7, 0.1, 1
        bezier=md3_accel, 0.3, 0, 0.8, 0.15
        bezier=overshot, 0.05, 0.9, 0.1, 1.1
        bezier=crazyshot, 0.1, 1.5, 0.76, 0.92
        bezier=hyprnostretch, 0.05, 0.9, 0.1, 1.0
        bezier=menu_decel, 0.1, 1, 0, 1
        bezier=menu_accel, 0.38, 0.04, 1, 0.07
        bezier=easeInOutCirc, 0.85, 0, 0.15, 1
        bezier=easeOutCirc, 0, 0.55, 0.45, 1
        bezier=easeOutExpo, 0.16, 1, 0.3, 1
        bezier=softAcDecel, 0.26, 0.26, 0.15, 1
        bezier=md2, 0.4, 0, 0.2, 1 # use with .2s duration
        animation=windows, 1, 3, md3_decel, popin 60%
        animation=windowsIn, 1, 3, md3_decel, popin 60%
        animation=windowsOut, 1, 3, md3_accel, popin 60%
        animation=border, 1, 10, default
        animation=fade, 1, 3, md3_decel
        animation=layers, 1, 2, md3_decel, slide
        animation=layersIn, 1, 3, menu_decel, slide
        animation=layersOut, 1, 1.6, menu_accel
        animation=fadeLayersIn, 1, 2, menu_decel
        animation=fadeLayersOut, 1, 4.5, menu_accel
        animation=workspaces, 1, 7, menu_decel, slide
        animation=workspaces, 1, 2.5, softAcDecel, slide
        animation=workspaces, 1, 7, menu_decel, slidefade 15%
        animation=specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
        animation=specialWorkspace, 1, 3, md3_decel, slidevert
        enabled=true
      }
      
      binds {
        scroll_event_delay=0
      }
      
      decoration {
        blur {
          brightness=1
          contrast=1
          enabled=true
          ignore_opacity=on
          new_optimizations=true
          noise=0.010000
          passes=4
          popups=true
          popups_ignorealpha=0.600000
          size=6
          special=false
          xray=true
        }
      
        shadow {
          color=rgba(0000002A)
          enabled=true
          ignore_window=true
          offset=0 2
          range=20
          render_power=4
        }
        dim_inactive=false
        dim_special=0
        dim_strength=0.100000
        rounding=20
      }
      
      dwindle {
        preserve_split=true
        smart_resizing=false
        smart_split=false
      }
      
      general {
        allow_tearing=true
        border_size=1
        col.active_border=rgba(ECDEEC39)
        col.inactive_border=rgba(9A8C9C30)
        gaps_in=4
        gaps_out=5
        gaps_workspaces=50
        layout=dwindle
        no_focus_fallback=true
        resize_on_border=true
      }
      
      gestures {
        workspace_swipe=true
        workspace_swipe_cancel_ratio=0.200000
        workspace_swipe_create_new=true
        workspace_swipe_direction_lock=true
        workspace_swipe_direction_lock_threshold=10
        workspace_swipe_distance=700
        workspace_swipe_fingers=3
        workspace_swipe_min_speed_to_force=5
      }
      
      input {
        touchpad {
          clickfinger_behavior=true
          disable_while_typing=true
          natural_scroll=true
          scroll_factor=0.500000
        }
        follow_mouse=1
        kb_layout=us,ir
        kb_options=grp:win_space_toggle
        numlock_by_default=true
        repeat_delay=250
        repeat_rate=35
        special_fallthrough=true
      }
      
      misc {
        allow_session_lock_restore=true
        animate_manual_resizes=false
        animate_mouse_windowdragging=false
        background_color=rgba(18111AFF)
        disable_hyprland_logo=true
        enable_swallow=false
        focus_on_activate=true
        force_default_wallpaper=0
        initial_workspace_tracking=false
        new_window_takes_over_fullscreen=2
        swallow_regex=(foot|kitty|allacritty|Alacritty)
        vfr=1
        vrr=1
      }
      
      plugin {
        hyprbars {
          bar_button_padding=5
          bar_color=rgba(18111AFF)
          bar_height=30
          bar_padding=10
          bar_part_of_window=true
          bar_precedence_over_border=true
          bar_text_font=Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif
          col.text=rgba(ECDEECFF)
          hyprbars-button=rgb(ECDEEC), 13, 󰖭, hyprctl dispatch killactive
          hyprbars-button=rgb(ECDEEC), 13, 󰖯, hyprctl dispatch fullscreen 1
          hyprbars-button=rgb(ECDEEC), 13, 󰖰, hyprctl dispatch movetoworkspacesilent special
        }
      
        hyprexpo {
          bg_col=rgb(000000)
          columns=3
          enable_gesture=false
          gap_size=5
          gesture_distance=300
          gesture_positive=false
          workspace_method=first 1
        }
      }
      bind=$Primary, A, exec, rofi -show drun
      bind=$Primary$Alternate, Q, exec, power-menu-rofi
      bind=$Primary$Secondary, K, exec, wallch --chgw
      bind=$Primary$Alternate, p, exec, dgpu_windows_vm_start
      bind=$Primary$Alternate, o, exec, dgpu_windows_vm_shutdown
      bind=$Primary$Alternate, i, exec, iaudio_dgpu_windows_vm_start
      bind=$Primary$Alternate, 0, exec, battery_toggle
      bind=$Primary$Alternate, 9, exec, tlp_mode
      bind=$Primary$Alternate, 8, exec, check_gpu_status
      bind=$Primary, 1, exec, vesktop
      bind=$Alternate, 1, exec, discord
      bind=$Primary, 2, exec, telegram-desktop
      bind=$Primary, M, exec, [float; size 50% 56%; move 100%-w-10 43] foot -e btop
      bind=$Alternate, M, exec, [float; size 50% 55%; move 100%-w-10 43] kitty -e btop
      bind=$Primary$Alternate, M, exec, missioncenter
      bind=$Primary, T, exec, foot
      bind=$Alternate, T, exec, kitty
      bind=$Primary$Secondary, T, exec, kitty -e nmtui
      bind=$Primary, E, exec, nautilus
      bind=$Alternate, E, exec, thunar
      bind=$Primary, B, exec, brave
      bind=$Alternate, B, exec, zen
      bind=$Primary$Secondary, X, exec, subl
      bind=$Primary, C, exec, code
      bind=,XF86Calculator, exec, ~/.local/bin/wofi-calc
      bind=$Primary$Secondary, I, exec, XDG_CURRENT_DESKTOP='gnome' gnome-control-center
      bind=$Primary$Secondary, V, exec, pavucontrol
      bind=$Primary$Tertiary, Home, exec, gnome-system-monitor
      bind=$Primary$Secondary, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji
      bind=$Alternate, F4, killactive,
      bind=$Secondary$Alternate, Space, togglefloating,
      bind=$Primary, Q, exec, hyprctl kill
      bind=$Primary$Tertiary$Alternate, Delete, exec, pkill wlogout || wlogout -p layer-shell
      bind=$Primary$Tertiary$Alternate$Secondary, Delete, exec, systemctl poweroff
      bind=$Secondary$Tertiary, D, exec,~/.local/bin/rubyshot | wl-copy
      bind=$Secondary$Tertiary, 4, exec, grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" - | wl-copy
      bind=$Secondary$Tertiary, 5, exec, ~/.config/ags/scripts/record-script.sh
      bind=$Secondary$Alternate, 5, exec, ~/.config/ags/scripts/record-script.sh --sound
      bind=$Secondary$Tertiary$Alternate, 5, exec, ~/.config/ags/scripts/record-script.sh --fullscreen-sound
      bind=$Secondary$Alternate, C, exec, hyprpicker -a
      bind=$Primary$Alternate, Space, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl
      bind=$Secondary$Alternate, V, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl
      bind=$Primary$Secondary$Tertiary,S,exec,grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" 'tmp.png' && tesseract 'tmp.png' - | wl-copy && rm 'tmp.png'
      bind=$Secondary$Tertiary, B, exec, playerctl previous
      bind=$Secondary$Tertiary, P, exec, playerctl play-pause
      bind=$Primary$Secondary, L, exec, hyprlock
      bind=$Primary$Secondary, Slash, exec, pkill anyrun || anyrun
      bind=$Secondary$Tertiary, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh
      bind=$Secondary$Tertiary, left, movewindow, l
      bind=$Secondary$Tertiary, right, movewindow, r
      bind=$Secondary$Tertiary, up, movewindow, u
      bind=$Secondary$Tertiary, down, movewindow, d
      bind=$Secondary, left, movefocus, l
      bind=$Secondary, right, movefocus, r
      bind=$Alternate, up, movefocus, u
      bind=$Alternate, down, movefocus, d
      bind=$Secondary, BracketLeft, movefocus, l
      bind=$Secondary, BracketRight, movefocus, r
      bind=$Primary$Secondary, right, workspace, +1
      bind=$Primary$Secondary, left, workspace, -1
      bind=$Primary$Secondary, BracketLeft, workspace, -1
      bind=$Primary$Secondary, BracketRight, workspace, +1
      bind=$Primary$Secondary, up, workspace, -5
      bind=$Primary$Secondary, down, workspace, +5
      bind=$Secondary, Page_Down, workspace, +1
      bind=$Secondary, Page_Up, workspace, -1
      bind=$Primary$Secondary, Page_Down, workspace, +1
      bind=$Primary$Secondary, Page_Up, workspace, -1
      bind=$Secondary$Alternate, Page_Down, movetoworkspace, +1
      bind=$Secondary$Alternate, Page_Up, movetoworkspace, -1
      bind=$Secondary$Tertiary, Page_Down, movetoworkspace, +1
      bind=$Secondary$Tertiary, Page_Up, movetoworkspace, -1
      bind=$Primary$Secondary$Tertiary, Right, movetoworkspace, +1
      bind=$Primary$Secondary$Tertiary, Left, movetoworkspace, -1
      bind=$Secondary$Tertiary, mouse_down, movetoworkspace, -1
      bind=$Secondary$Tertiary, mouse_up, movetoworkspace, +1
      bind=$Secondary$Alternate, mouse_down, movetoworkspace, -1
      bind=$Secondary$Alternate, mouse_up, movetoworkspace, +1
      bind=$Primary$Secondary, F, fullscreen, 0
      bind=$Primary$Secondary, D, fullscreen, 1
      bind=$Secondary, 1, workspace, 1
      bind=$Secondary, 2, workspace, 2
      bind=$Secondary, 3, workspace, 3
      bind=$Secondary, 4, workspace, 4
      bind=$Secondary, 5, workspace, 5
      bind=$Secondary, 6, workspace, 6
      bind=$Secondary, 7, workspace, 7
      bind=$Secondary, 8, workspace, 8
      bind=$Secondary, 9, workspace, 9
      bind=$Secondary, 0, workspace, 10
      bind=$Primary$Secondary, S, togglespecialworkspace,
      bind=$Alternate, Tab, cyclenext
      bind=$Alternate, Tab, bringactivetotop,
      bind=$Secondary $Alternate, 1, movetoworkspacesilent, 1
      bind=$Secondary $Alternate, 2, movetoworkspacesilent, 2
      bind=$Secondary $Alternate, 3, movetoworkspacesilent, 3
      bind=$Secondary $Alternate, 4, movetoworkspacesilent, 4
      bind=$Secondary $Alternate, 5, movetoworkspacesilent, 5
      bind=$Secondary $Alternate, 6, movetoworkspacesilent, 6
      bind=$Secondary $Alternate, 7, movetoworkspacesilent, 7
      bind=$Secondary $Alternate, 8, movetoworkspacesilent, 8
      bind=$Secondary $Alternate, 9, movetoworkspacesilent, 9
      bind=$Secondary $Alternate, 0, movetoworkspacesilent, 10
      bind=$Primary$Tertiary$Secondary, Up, movetoworkspacesilent, special
      bind=$Secondary$Alternate, S, movetoworkspacesilent, special
      bind=$Secondary, mouse_up, workspace, +1
      bind=$Secondary, mouse_down, workspace, -1
      bind=$Primary$Secondary, mouse_up, workspace, +1
      bind=$Primary$Secondary, mouse_down, workspace, -1
      bind=Primary$Secondary, Backslash, resizeactive, exact 640 480
      bind=Secondary$Alternate, J, exec, ydotool key 105:1 105:0 
      binde=$Primary$Secondary, Minus, splitratio, -0.1
      binde=$Primary$Secondary, Equal, splitratio, 0.1
      binde=$Secondary, Semicolon, splitratio, -0.1
      binde=$Secondary, Apostrophe, splitratio, 0.1
      bindl=, XF86AudioMute, exec, sh -c "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($2==0) ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic"}') '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
      bindl=,Print,exec,grim - | wl-copy
      bindl=, XF86AudioNext, exec, playerctl next
      bindl=, XF86AudioPrev, exec, playerctl previous
      bindl=, XF86AudioPlay, exec, playerctl play-pause
      bindl=$Secondary$Tertiary, L, exec, sleep 0.1 && systemctl suspend
      bindle=, XF86AudioRaiseVolume, exec, sh -c "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-high-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
      bindle=, XF86AudioLowerVolume, exec, sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-low-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
      bindle=, XF86MonBrightnessUp, exec, bash -c 'brightnessctl set 5%+ && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-high-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
      bindle=, XF86MonBrightnessDown, exec, bash -c 'brightnessctl set 5%- && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-low-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
      bindm=$Primary, mouse:273, resizewindow
      bindm=$Primary$Secondary, mouse:273, resizewindow
      bindm=,mouse:274, movewindow
      bindm=$Secondary, mouse:273, movewindow
      bindm=$Primary$Secondary, Z, movewindow
      bindr=$Primary$Secondary, R, exec, hyprctl reload; pkill waybar; pkill activewin.sh; pkill activews.sh; pkill gohypr; pkill bash; pkill ydotool; waybar &
      env=AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/renderD128
      env=QT_IM_MODULE, fcitx
      env=XMODIFIERS, @im=fcitx
      env=SDL_IM_MODULE, fcitx
      env=GLFW_IM_MODULE, ibus
      env=INPUT_METHOD, fcitx
      env=QT_QPA_PLATFORM, wayland
      env=QT_QPA_PLATFORMTHEME, qt5ct
      env=WLR_NO_HARDWARE_CURSORS, 1
      env=XCURSOR_SIZE,24
      exec=blueman-tray &
      exec=xhost +SI:localuser:root
      exec-once=swww-daemon --format xrgb
      exec-once=/usr/lib/geoclue-2.0/demos/agent & gammastep
      exec-once=waybar &
      exec-once=easyeffects --gapplication-service &
      exec-once=fcitx5
      exec-once=gnome-keyring-daemon --start --components=secrets
      exec-once=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1
      exec-once=hypridle
      exec-once=dbus-update-activation-environment --all
      exec-once=sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once=hyprpm reload
      exec-once=polkit-kde-authentication-agent-1
      exec-once=wl-paste --type text --watch cliphist store
      exec-once=wl-paste --type image --watch cliphist store
      exec-once=hyprctl setcursor Bibata-Modern-Classic 24
      exec-once=touchegg
      exec-once=nm-applet &
      exec-once=hyprlock
      exec-once=sleep 7 && reattach_safe
      exec-once=notifx1 startup & disown
      layerrule=xray 1, .*
      layerrule=noanim, walker
      layerrule=noanim, selection
      layerrule=noanim, overview
      layerrule=noanim, anyrun
      layerrule=noanim, indicator.*
      layerrule=noanim, osk
      layerrule=noanim, hyprpicker
      layerrule=blur, shell:*
      layerrule=ignorealpha 0.6, shell:*
      layerrule=noanim, noanim
      layerrule=blur, gtk-layer-shell
      layerrule=ignorezero, gtk-layer-shell
      layerrule=blur, launcher
      layerrule=ignorealpha 0.5, launcher
      layerrule=blur, notifications
      layerrule=ignorealpha 0.69, notifications
      layerrule=blur, waybar
      layerrule=ignorealpha 0.05, waybar
      layerrule=ignorezero, waybar
      layerrule=blur, rofi
      layerrule=ignorealpha 0.05, rofi
      layerrule=ignorezero, rofi
      monitor=,preferred,auto,1
      monitor=HDMI-A-1,1920x1080@60,1920x0,1,mirror,eDP-1
      windowrule=float, ^(blueberry.py)$
      windowrule=float, ^(steam)$
      windowrule=float, ^(guifetch)$ # FlafyDev/guifetch
      windowrule=center, title:^(Open File)(.*)$
      windowrule=center, title:^(Select a File)(.*)$
      windowrule=center, title:^(Choose wallpaper)(.*)$
      windowrule=center, title:^(Open Folder)(.*)$
      windowrule=center, title:^(Save As)(.*)$
      windowrule=center, title:^(Library)(.*)$
      windowrule=center, title:^(File Upload)(.*)$
      windowrule=float,title:^(Open File)(.*)$
      windowrule=float,title:^(Select a File)(.*)$
      windowrule=float,title:^(Choose wallpaper)(.*)$
      windowrule=float,title:^(Open Folder)(.*)$
      windowrule=float,title:^(Save As)(.*)$
      windowrule=float,title:^(Library)(.*)$
      windowrule=float,title:^(File Upload)(.*)$
      windowrule=immediate,.*.exe
      windowrulev2=bordercolor rgba(ECB2FFAA) rgba(ECB2FF77),pinned:1
      windowrulev2=tile, class:(dev.warp.Warp)
      windowrulev2=float, title:^([Pp]icture[-s]?[Ii]n[-s]?[Pp]icture)(.*)$
      windowrulev2=opacity 0.80 0.80,class:^(code)$
      windowrulev2=opacity 0.80 0.80,class:^(zen)$
      windowrulev2=opacity 0.80 0.80,class:^(brave)$
      windowrulev2=opacity 0.80 0.80,class:^(amberol)$
      windowrulev2=opacity 0.80 0.80,class:^(vesktop)$
      windowrulev2=opacity 0.80 0.80,class:^(discord)$
      windowrulev2=opacity 0.80 0.80,class:^(nautilus)$
      windowrulev2=opacity 0.80 0.80,class:^(thunar)$
      windowrulev2=opacity 0.80 0.80,class:^(rofi)$
      windowrulev2=immediate,class:(steam_app)
      windowrulev2=noshadow,floating:0
      '';
      };
    };
  }

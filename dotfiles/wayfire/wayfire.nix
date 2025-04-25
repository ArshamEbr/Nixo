{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/wayfire.ini".text = ''
        [alpha]
        min_value = 0.100000
        modifier = <super> KEY_RIGHTBRACE
        
        [animate]
        close_animation = fire
        duration = 300ms circle
        enabled_for = ((type equals "toplevel" | (type equals "x-or" & focusable equals true)) & (!(app_id equals "nwgbar" | app_id equals "nwggrid")))
        fade_duration = 100ms circle
        fade_enabled_for = type equals "overlay"
        fire_color = \#3584E4FF
        fire_duration = 400ms circle
        fire_enabled_for = none
        fire_particle_size = 17.000000
        fire_particles = 1500
        open_animation = fire
        random_fire_color = false
        startup_duration = 100ms circle
        zoom_duration = 200ms circle
        zoom_enabled_for = none
        
        [annotate]
        clear_workspace = <alt> <super> KEY_C
        draw = <alt> <super> BTN_LEFT
        from_center = true
        line_width = 3.000000
        method = draw
        stroke_color = \#FF0000FF
        
        [autorotate-iio]
        lock_rotation = false
        rotate_down = <ctrl> <super> KEY_DOWN
        rotate_left = <ctrl> <super> KEY_LEFT
        rotate_right = <ctrl> <super> KEY_RIGHT
        rotate_up = <ctrl> <super> KEY_UP
        
        [autostart]
        autostart0 = udiskie &
        autostart1 = notifx1 startup & disown
        autostart10 = sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        autostart11 = polkit-kde-authentication-agent-1
        autostart12 = easyeffects --gapplication-service &
        autostart13 = xhost +SI:localuser:root
        autostart14 = blueman-tray &
        autostart2 = sleep 7 && reattach_safe
        autostart3 = hyprlock
        autostart4 = nm-applet &
        autostart5 = touchegg
        autostart6 = gnome-keyring-daemon --start --components=secrets
        autostart7 = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1
        autostart8 = hypridle
        autostart9 = dbus-update-activation-environment --all
        autostart_wf_shell = false
        background_rotate = swww-daemon --format xrgb
        notifications = mako &
        waybar = waybar &
        
        [background-view]
        command = mpv --loop=inf
        file = 
        
        [bench]
        average_frames = 1
        frames_per_update = 3
        position = top_center
        
        [blur]
        blur_by_default = type is "toplevel"
        bokeh_degrade = 4
        bokeh_iterations = 56
        bokeh_offset = 2.400000
        box_degrade = 2
        box_iterations = 3
        box_offset = 1.900000
        gaussian_degrade = 1
        gaussian_iterations = 14
        gaussian_offset = 1.200000
        kawase_degrade = 2
        kawase_iterations = 2
        kawase_offset = 4.300000
        method = kawase
        mode = normal
        saturation = 1.000000
        toggle = none
        
        [command]
        binding_0 = <super> KEY_C
        binding_1 = <super> KEY_2
        binding_10 = <ctrl> <super> KEY_T
        binding_11 = <alt> KEY_T
        binding_12 = <super> KEY_1
        binding_13 = <alt> KEY_1
        binding_14 = <super> KEY_A
        binding_15 = <alt> <super> KEY_0
        binding_16 = <alt> <super> KEY_9
        binding_17 = <alt> <super> KEY_8
        binding_18 = <alt> <super> KEY_P
        binding_19 = <alt> <super> KEY_O
        binding_2 = <ctrl> <super> KEY_R
        binding_20 = <alt> <super> KEY_I
        binding_21 = KEY_CALC
        binding_22 = <shift> <ctrl> KEY_4
        binding_23 = <shift> <ctrl> KEY_I
        binding_24 = <super> KEY_M
        binding_25 = <alt> KEY_M
        binding_26 = <alt> <super> KEY_M
        binding_3 = KEY_PLAYPAUSE
        binding_4 = KEY_NEXTSONG
        binding_5 = KEY_PREVIOUSSONG
        binding_6 = <super> KEY_B
        binding_7 = <alt> KEY_B
        binding_8 = <super> KEY_E
        binding_9 = <alt> KEY_E
        binding_mute = KEY_MUTE
        binding_terminal = <super> KEY_T
        command_0 = code
        command_1 = telegram-desktop
        command_10 = kitty -e nmtui
        command_11 = kitty
        command_12 = vesktop
        command_13 = discord
        command_14 = rofi -show drun
        command_15 = battery_toggle
        command_16 = tlp_mode
        command_17 = check_gpu_status
        command_18 = dgpu_windows_vm_start
        command_19 = dgpu_windows_vm_shutdown
        command_2 = pkill waybar; pkill activewin.sh; pkill activews.sh; pkill gohypr; pkill bash; pkill ydotool; waybar &
        command_20 = iaudio_dgpu_windows_vm_start
        command_21 = ~/.local/bin/wofi-calc
        command_22 = grim -g "$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)" - | wl-copy
        command_23 = XDG_CURRENT_DESKTOP='gnome' gnome-control-center
        command_24 = [float; size 50% 56%; move 100%-w-10 43] foot -e btop
        command_25 = [float; size 50% 55%; move 100%-w-10 43] kitty -e btop
        command_26 = missioncenter
        command_3 = playerctl play-pause
        command_4 = playerctl next
        command_5 = playerctl previous
        command_6 = brave
        command_7 = zen
        command_8 = nautilus
        command_9 = thunar
        command_light_down = bash -c 'brightnessctl set 5%- && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-low-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
        command_light_up = bash -c 'brightnessctl set 5%+ && notify-send -h string:x-canonical-private-synchronous:brightness-sync -u low -i display-brightness-high-symbolic "󰃠 Brightness" -h int:value:$(( $(brightnessctl get) * 100 / $(brightnessctl max) )) -t 1000'
        command_mute = sh -c "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($2==0) ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic"}') '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        command_terminal = foot
        command_volume_down = sh -c "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-low-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        command_volume_up = sh -c "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -h string:x-canonical-private-synchronous:volume-sync -u low -i audio-volume-high-symbolic '󰝚 Volume' -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}') -t 1000"
        repeatable_binding_light_down = KEY_BRIGHTNESSDOWN
        repeatable_binding_light_up = KEY_BRIGHTNESSUP
        repeatable_binding_volume_down = KEY_VOLUMEDOWN
        repeatable_binding_volume_up = KEY_VOLUMEUP
        
        [core]
        background_color = \#1A1A1AFF
        close_top_view = <super> KEY_Q | <alt> KEY_F4
        focus_button_with_modifiers = false
        focus_buttons = BTN_LEFT | BTN_MIDDLE | BTN_RIGHT
        focus_buttons_passthrough = true
        max_render_time = 9
        plugins = animate autostart command cube fast-switcher fisheye move oswitch place resize switcher vswitch window-rules wrot zoom vswipe wm-actions matcher extra-gestures wobbly scale annotate grid shortcuts-inhibit water ghost hide-cursor idle expo blur decoration session-lock alpha
        preferred_decoration_mode = client
        transaction_timeout = 100
        vheight = 4
        vwidth = 4
        xwayland = true
        
        [crosshair]
        line_color = \#FF0000FF
        line_width = 2
        
        [cube]
        activate = <ctrl> <super> KEY_UP
        background = \#1A1A1AFF
        background_mode = simple
        cubemap_image = 
        deform = 1
        initial_animation = 350ms easeOutElastic
        light = true
        reset_radius = 25.000000
        rotate_left = <ctrl> <super> KEY_LEFT
        rotate_right = <ctrl> <super> KEY_RIGHT
        skydome_mirror = true
        skydome_texture = 
        speed_spin_horiz = 0.020000
        speed_spin_vert = 0.020000
        speed_zoom = 0.070000
        zoom = 0.100000
        
        [decoration]
        active_color = \#1A5FB4FF
        border_size = 2
        button_order = minimize maximize close
        font = sans-serif
        ignore_views = none
        inactive_color = \#333333DD
        title_height = 0
        
        [expo]
        background = \#1A1A1AFF
        binding_1 = <ctrl> KEY_1
        binding_2 = <ctrl> KEY_2
        binding_3 = <ctrl> KEY_3
        binding_4 = <ctrl> KEY_4
        binding_5 = <ctrl> KEY_5
        binding_6 = <ctrl> KEY_6
        binding_7 = <ctrl> KEY_7
        duration = 200ms sigmoid
        inactive_brightness = 0.700000
        keyboard_interaction = true
        offset = 10
        toggle = <super> 
        transition_length = 200
        
        [extra-gestures]
        close_fingers = 20
        move_delay = 500
        move_fingers = 3
        
        [fast-switcher]
        activate = <alt> KEY_ESC
        activate_backward = <alt> <shift> KEY_ESC
        inactive_alpha = 0.700000
        
        [fisheye]
        radius = 450.000000
        toggle = <ctrl> <super> KEY_I
        zoom = 7.000000
        
        [focus-change]
        cross-output = false
        cross-workspace = false
        down = <shift> <super> KEY_DOWN
        grace-down = 1
        grace-left = 1
        grace-right = 1
        grace-up = 1
        left = <shift> <super> KEY_LEFT
        raise-on-change = true
        right = <shift> <super> KEY_RIGHT
        scan-height = 0
        scan-width = 0
        up = <shift> <super> KEY_UP
        
        [focus-steal-prevent]
        cancel_keys = KEY_ENTER
        deny_focus_views = none
        timeout = 1000
        
        [follow-focus]
        change_output = true
        change_view = true
        focus_delay = 50
        raise_on_top = true
        threshold = 10
        
        [force-fullscreen]
        constrain_pointer = false
        constraint_area = view
        key_toggle_fullscreen = <alt> <super> KEY_F
        preserve_aspect = true
        transparent_behind_views = true
        x_skew = 0.000000
        y_skew = 0.000000
        
        [foreign-toplevel]
        
        [ghost]
        ghost_match = 
        ghost_toggle = <ctrl> <super> KEY_S
        
        [grid]
        duration = 0ms circle
        restore = <super> KEY_DOWN | <super> KEY_KP0
        slot_b = <super> KEY_KP2
        slot_bl = <super> KEY_KP1
        slot_br = <super> KEY_KP3
        slot_c = <super> KEY_UP | <super> KEY_KP5
        slot_l = <super> KEY_LEFT | <super> KEY_KP4
        slot_r = <super> KEY_RIGHT | <super> KEY_KP6
        slot_t = <super> KEY_KP8
        slot_tl = <super> KEY_KP7
        slot_tr = <super> KEY_KP9
        type = wobbly
        
        [gtk-shell]
        
        [hide-cursor]
        hide_delay = 2000
        toggle = <ctrl> <super> KEY_H
        
        [idle]
        cube_max_zoom = 1.500000
        cube_rotate_speed = 1.000000
        cube_zoom_speed = 1000
        disable_initially = false
        disable_on_fullscreen = true
        dpms_timeout = -1
        screensaver_timeout = 3600
        toggle = <alt> <super> KEY_X
        
        [input]
        click_method = default
        cursor_size = 24
        cursor_theme = Bibata-Modern-Classic
        disable_touchpad_while_mouse = false
        disable_touchpad_while_typing = true
        drag_lock = false
        gesture_sensitivity = 1.000000
        kb_capslock_default_state = false
        kb_numlock_default_state = false
        kb_repeat_delay = 400
        kb_repeat_rate = 40
        left_handed_mode = false
        middle_emulation = false
        modifier_binding_timeout = 400
        mouse_accel_profile = default
        mouse_cursor_speed = 0.000000
        mouse_natural_scroll = false
        mouse_scroll_speed = 1.000000
        natural_scroll = true
        scroll_method = default
        tablet_motion_mode = default
        tap_to_click = true
        touchpad_accel_profile = default
        touchpad_cursor_speed = 0.000000
        touchpad_scroll_speed = 1.000000
        xkb_layout = us
        xkb_model = 
        xkb_options = ctrl:nocaps
        xkb_rules = evdev
        xkb_variant = 
        
        [input-device]
        output = 
        
        [input-method-v1]
        enable_text_input_v1 = true
        enable_text_input_v3 = true
        
        [invert]
        preserve_hue = false
        toggle = <super> KEY_I
        
        [ipc]
        
        [ipc-rules]
        
        [join-views]
        
        [keycolor]
        color = \#000000FF
        opacity = 0.250000
        threshold = 0.500000
        
        [mag]
        default_height = 500
        toggle = <alt> <super> KEY_M
        zoom_level = 75
        
        [move]
        activate = <super> BTN_LEFT
        enable_snap = true
        enable_snap_off = true
        join_views = false
        preview_base_border = \#404080CC
        preview_base_color = \#8080FF80
        preview_border_width = 3
        quarter_snap_threshold = 50
        snap_off_threshold = 10
        snap_threshold = 10
        workspace_switch_after = -1
        
        [obs]
        
        [oswitch]
        next_output = <super> KEY_O
        next_output_with_win = <shift> <super> KEY_O
        prev_output = 
        prev_output_with_win = 
        
        [output]
        depth = 8
        mode = auto
        position = auto
        scale = 1.000000
        transform = normal
        vrr = false
        
        [pin-view]
        
        [place]
        mode = center
        
        [preserve-output]
        last_output_focus_timeout = 10000
        
        [resize]
        activate = <super> BTN_RIGHT
        activate_preserve_aspect = none
        
        [scale]
        allow_zoom = false
        bg_color = \#1A1A1AE6
        close_on_new_view = false
        duration = 2000ms circle
        inactive_alpha = 0.750000
        include_minimized = false
        interact = false
        middle_click_close = false
        minimized_alpha = 0.450000
        outer_margin = 0
        spacing = 50
        text_color = \#CCCCCCFF
        title_font_size = 16
        title_overlay = all
        title_position = center
        toggle = <super> KEY_P
        toggle_all = 
        
        [scale-title-filter]
        bg_color = \#00000080
        case_sensitive = false
        font_size = 30
        overlay = true
        share_filter = false
        text_color = \#CCCCCCCC
        
        [session-lock]
        
        [shortcuts-inhibit]
        break_grab = none
        ignore_views = none
        inhibit_by_default = none
        
        [showrepaint]
        reduce_flicker = true
        toggle = <alt> <super> KEY_S
        
        [simple-tile]
        animation_duration = 0ms circle
        button_move = <super> BTN_LEFT
        button_resize = <super> BTN_RIGHT
        inner_gap_size = 5
        keep_fullscreen_on_adjacent = true
        key_focus_above = <super> KEY_K
        key_focus_below = <super> KEY_J
        key_focus_left = <super> KEY_H
        key_focus_right = <super> KEY_L
        key_toggle = <super> KEY_T
        outer_horiz_gap_size = 0
        outer_vert_gap_size = 0
        preview_base_border = \#404080CC
        preview_base_color = \#8080FF80
        preview_border_width = 3
        tile_by_default = all
        
        [switcher]
        next_view = <alt> KEY_TAB
        prev_view = <alt> <shift> KEY_TAB
        speed = 600ms circle
        view_thumbnail_rotation = 30
        view_thumbnail_scale = 1.500000
        
        [view-shot]
        capture = <alt> <super> BTN_MIDDLE
        command = notify-send "The view under cursor was captured to %f"
        filename = /tmp/snapshot-%F-%T.png
        
        [vswipe]
        background = \#241F31FF
        delta_threshold = 24.000000
        duration = 320ms circle
        enable_free_movement = true
        enable_horizontal = true
        enable_smooth_transition = true
        enable_vertical = true
        fingers = 3
        gap = 32.000000
        speed_cap = 0.050000
        speed_factor = 256.000000
        threshold = 0.350000
        
        [vswitch]
        background = \#1A1A1AFF
        binding_down = <alt> <ctrl> KEY_DOWN
        binding_last = 
        binding_left = <alt> <ctrl> KEY_LEFT
        binding_right = <alt> <ctrl> KEY_RIGHT
        binding_up = <alt> <ctrl> KEY_UP
        binding_win_down = <alt> <ctrl> <shift> KEY_DOWN
        binding_win_left = <alt> <ctrl> <shift> KEY_LEFT
        binding_win_right = <alt> <ctrl> <shift> KEY_RIGHT
        binding_win_up = <alt> <ctrl> <shift> KEY_UP
        duration = 300ms circle
        gap = 20
        send_win_down = 
        send_win_last = 
        send_win_left = 
        send_win_right = 
        send_win_up = 
        with_win_down = 
        with_win_last = 
        with_win_left = <alt> <shift> <super> KEY_LEFT
        with_win_right = <alt> <shift> <super> KEY_RIGHT
        with_win_up = <alt> <shift> <super> KEY_UP
        wraparound = false
        
        [water]
        activate = <ctrl> <super> BTN_LEFT
        
        [wayfire-shell]
        toggle_menu = <super> 
        
        [window-rules]
        
        [winzoom]
        dec_x_binding = <ctrl> <super> KEY_LEFT
        dec_y_binding = <ctrl> <super> KEY_UP
        inc_x_binding = <ctrl> <super> KEY_RIGHT
        inc_y_binding = <ctrl> <super> KEY_DOWN
        modifier = <ctrl> <super> 
        nearest_filtering = false
        preserve_aspect = true
        zoom_step = 0.100000
        
        [wm-actions]
        minimize = none
        send_to_back = none
        toggle_always_on_top = <ctrl> <shift> KEY_T
        toggle_fullscreen = <ctrl> <super> KEY_F
        toggle_maximize = none
        toggle_showdesktop = none
        toggle_sticky = <ctrl> <shift> KEY_S
        
        [wobbly]
        friction = 3.700000
        grid_resolution = 6
        spring_k = 8.800000
        
        [workarounds]
        all_dialogs_modal = true
        app_id_mode = stock
        discard_command_output = true
        dynamic_repaint_delay = false
        enable_input_method_v2 = false
        enable_opaque_region_damage_optimizations = false
        enable_so_unloading = false
        force_preferred_decoration_mode = false
        remove_output_limits = false
        use_external_output_configuration = false
        
        [workspace-names]
        background_color = \#333333B3
        background_radius = 30.000000
        display_duration = 500
        font = sans-serif
        margin = 0
        position = center
        show_option_names = false
        text_color = \#FFFFFFFF
        
        [wrot]
        activate = <ctrl> <super> BTN_RIGHT
        activate-3d = <shift> <super> BTN_RIGHT
        invert = false
        reset = <ctrl> <super> KEY_R
        reset-one = <super> KEY_R
        reset_radius = 25.000000
        sensitivity = 24
        
        [wsets]
        label_duration = 2000ms linear
        
        [xdg-activation]
        
        [zoom]
        interpolation_method = 0
        modifier = <ctrl> <super> 
        smoothing_duration = 300ms circle
        speed = 0.010000    
      '';
      };
    };
    programs.wayfire = {
      enable = true;
      package = pkgs-unstable.wayfire;
      plugins = with pkgs-unstable.wayfirePlugins; [
        wcm
        wf-shell
        wayfire-plugins-extra
      ];
    };
  }

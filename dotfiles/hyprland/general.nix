{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/hypr/general.conf".text = ''
      # Monitors Configuration
      monitor = ,preferred,auto,1
      monitor = HDMI-A-1,1920x1080@60,1920x0,1,mirror,eDP-1 # Mirror
    #  monitor = HDMI-A-1,1920x1080@60,1920x0,1 # Extand

      input {
        touchpad {
          clickfinger_behavior = true
          disable_while_typing = true
          natural_scroll = true
          scroll_factor = 0.500000
        }
        follow_mouse = 1
        kb_layout = us,ir # change to yours
        kb_options = grp:win_space_toggle
        numlock_by_default = true
        repeat_delay = 250
        repeat_rate = 35
        special_fallthrough = true
      }

      binds {
        scroll_event_delay = 0 # focus_window_on_workspace_c# For Auto-run stuff see execs.confhange = true
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_cancel_ratio = 0.200000
        workspace_swipe_create_new = true
        workspace_swipe_direction_lock = true
        workspace_swipe_direction_lock_threshold = 10
        workspace_swipe_distance = 700
        workspace_swipe_fingers = 3
        workspace_swipe_min_speed_to_force = 5
      }

      dwindle {
        preserve_split = true
      # no_gaps_when_only = 1
        smart_resizing = false
        smart_split = false
      }

      general {
        allow_tearing = true # This just allows the `immediate` window rule to work
      # focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        # Gaps and border
        border_size = 1
        gaps_in = 4
        gaps_out = 5
        gaps_workspaces = 50

        layout = dwindle
        no_focus_fallback = true
        resize_on_border = true
      }

      decoration {
        blur {
          enabled = true
          brightness = 1
          contrast = 1
          ignore_opacity = on
          new_optimizations = true
          noise = 0.010000
          passes = 4
          popups = true
          popups_ignorealpha = 0.600000
          size = 6
          special = false
          xray = true
        }
      
        shadow {
          enabled = true
          color = rgba(0000002A)
          ignore_window = true
          offset= 0 2
          range = 20
          render_power = 4
        }

      # Shader
      # screen_shader = ~/.config/hypr/shaders/nothing.frag
      # screen_shader = ~/.config/hypr/shaders/vibrance.frag

        rounding=20

        # Dim
        dim_inactive = false
        dim_special = 0
        dim_strength = 0.100000
      }

      animations {
        enabled = true

        # Animation curves
        bezier = linear, 0, 0, 1, 1
        bezier = md3_standard, 0.2, 0, 0, 1
        bezier = md3_decel, 0.05, 0.7, 0.1, 1
        bezier = md3_accel, 0.3, 0, 0.8, 0.15
        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = crazyshot, 0.1, 1.5, 0.76, 0.92
        bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
        bezier = menu_decel, 0.1, 1, 0, 1
        bezier = menu_accel, 0.38, 0.04, 1, 0.07
        bezier = easeInOutCirc, 0.85, 0, 0.15, 1
        bezier = easeOutCirc, 0, 0.55, 0.45, 1
        bezier = easeOutExpo, 0.16, 1, 0.3, 1
        bezier = softAcDecel, 0.26, 0.26, 0.15, 1
        bezier = md2, 0.4, 0, 0.2, 1 # use with .2s duration

        # Animation configs
        animation = windows, 1, 3, md3_decel, popin 60%
        animation = windowsIn, 1, 3, md3_decel, popin 60%
        animation = windowsOut, 1, 3, md3_accel, popin 60%
        animation = border, 1, 10, default
        animation = fade, 1, 3, md3_decel
        animation = layers, 1, 2, md3_decel, slide
        animation = layersIn, 1, 3, menu_decel, slide
        animation = layersOut, 1, 1.6, menu_accel
        animation = fadeLayersIn, 1, 2, menu_decel
        animation = fadeLayersOut, 1, 4.5, menu_accel
        animation = workspaces, 1, 7, menu_decel, slide
        animation = workspaces, 1, 2.5, softAcDecel, slide
        animation = workspaces, 1, 7, menu_decel, slidefade 15%
        animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
        animation = specialWorkspace, 1, 3, md3_decel, slidevert
      }

      misc {
        allow_session_lock_restore = true
        animate_manual_resizes = false
        animate_mouse_windowdragging = false
        background_color = rgba(18111AFF)
        disable_hyprland_logo = true
        enable_swallow = false
        focus_on_activate = true
        force_default_wallpaper = 0
        initial_workspace_tracking = false
        new_window_takes_over_fullscreen = 2
        swallow_regex = (foot|kitty|allacritty|Alacritty)
      # layers_hog_mouse_focus = true
        vfr = 1
        vrr = 1
      }

      plugin {
        hyprexpo {
          workspace_method = first 1
          bg_col = rgb(000000)
          columns = 3
          gap_size = 5

          enable_gesture = false
          gesture_distance = 300
          gesture_positive = false
        }
      }
      '';
      };
    };
  }

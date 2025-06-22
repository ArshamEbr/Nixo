{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    wayland.windowManager.hyprland.settings = {

      monitor = [
        ",preferred,auto,1"
        "HDMI-A-1,1920x1080@60,1920x0,1,mirror,eDP-1" # Duplicate
        # "HDMI-A-1,1920x1080@60,1920x0,1" # Extend
      ];
    
      input = {
        touchpad = {
          clickfinger_behavior = true;
          disable_while_typing = true;
          natural_scroll = true;
          scroll_factor = 0.5;
        };
        follow_mouse = 1;
        kb_layout = "us,ir"; # TODO change to yours
        kb_options = "grp:win_space_toggle";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        special_fallthrough = true;
      };
    
      binds = {
        scroll_event_delay = 0; 
      # focus_window_on_workspace_change = true (commented)
      };
    
      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_create_new = true;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_distance = 700;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_speed_to_force = 5;
      };
    
      dwindle = {
        preserve_split = true;
        # no_gaps_when_only = 1
        smart_resizing = false;
        smart_split = false;
      };
    
      general = {
        allow_tearing = true; # This just allows the `immediate` window rule to work
        # focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        border_size = 1;
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;
        layout = "dwindle";
        no_focus_fallback = true;
        resize_on_border = true;
      };
    
      decoration = {
        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          ignore_opacity = "on";
          new_optimizations = true;
          noise = 0.01;
          passes = 4;
          popups = true;
          popups_ignorealpha = 0.6;
          size = 6;
          special = false;
          xray = true;
        };
    
        shadow = {
          enabled = true;
          color = "rgba(0000002A)";
          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 4;
        };
    
        # screen_shader = ~/.config/hypr/shaders/nothing.frag
        # screen_shader = ~/.config/hypr/shaders/vibrance.frag
    
        rounding = 20;
    
        dim_inactive = false;
        dim_special = 0;
        dim_strength = 0.1;
      };
    
      misc = {
        allow_session_lock_restore = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        background_color = "rgba(18111AFF)";
        disable_hyprland_logo = true;
        enable_swallow = false;
        focus_on_activate = true;
        force_default_wallpaper = 0;
        initial_workspace_tracking = false;
        new_window_takes_over_fullscreen = 2;
        swallow_regex = "(foot|kitty|allacritty|Alacritty)";
        # layers_hog_mouse_focus = true
        vfr = 1;
        vrr = 1;
      };
    
      plugin.hyprexpo = {
        workspace_method = "first 1";
        bg_col = "rgb(000000)";
        columns = 3;
        gap_size = 5;
        enable_gesture = false;
        gesture_distance = 300;
        gesture_positive = false;
      };
    };
  }
{ pkgs, config, lib, user, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/wayfire.ini".text = ''
        [core]
        plugins = \
          alpha \
          animate \
          blur \
          wobbly \
          move \
          resize \
          switcher \
          vswitch \
          zoom \
          grid \
          autostart \
          wayfire-shell
        
        [blur]
        method = kawase
        kawase_offset = 2
        kawase_degrade = 3
        kawase_iterations = 3
        
        [animate]
        open = default
        close = default
        minimize = zoom
        unminimize = zoom
        duration = 300
        
        [alpha]
        modifier = <super> <alt>
        
        [move]
        activate = <super> BTN_LEFT
        
        [resize]
        activate = <super> BTN_RIGHT
        
        [zoom]
        modifier = <super>
        
        [autostart]
        0_env = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
        autostart_wf_shell = true
        
        [output:*]
        mode = 1920x1080@60000
        scale = 1.0
      '';
      };
    };
  }

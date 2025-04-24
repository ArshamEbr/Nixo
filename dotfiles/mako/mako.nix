{ pkgs, config, lib, user, pkgs-unstable, ... }:{

  dotfiles = {
      username = "${user.name}";
      files = {
      ".config/mako/config".text = ''
        max-visible=5
        sort=-time
        
        layer=overlay
        anchor=top-right
        
        font=JetBrainsMono Nerd Font 12
        background-color=#1e1e2e
        text-color=#cdd6f4
        width=390
        height=100
        margin=30
        padding=15
        border-size=2
        border-color=#89b4fa
        border-radius=17
        progress-color=over #5588AAFF
        icons=true
        max-icon-size=50
        
        markup=true
        actions=true
        format=<b>%s</b>\n%b
        default-timeout=7000
        ignore-timeout=false
        
        
        [urgency=low]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
        
        [category=volume]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
        
        [category=brightness]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
      '';
      };
    };
    environment.systemPackages = with pkgs-unstable; [
      mako
    ];
  }

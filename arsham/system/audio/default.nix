{ 
  pkgs,
  ...
}:

{
  imports = [ ./sfx.nix ];
  
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      # Low-latency settings:
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
  };
  
  systemd.user.services.easyeffects = {
    enable = true;
    description = "EasyEffects GApplication service";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
    };
  };
  
  environment.systemPackages = with pkgs; [
    # Audio plugins and utilities
    ladspaPlugins
    calf
    lsp-plugins
    easyeffects
    alsa-utils
    libspatialaudio
    pipewire
    pulseaudio
    
    # Development headers
    libpulseaudio.dev
  ];
}
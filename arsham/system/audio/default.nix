{
  pkgs,
  ...
}:

{
  imports = [./sfx.nix];
  
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
    # Audio.
    ladspaPlugins
    calf
    lsp-plugins
    easyeffects
    alsa-utils

    # Sound
    libspatialaudio
    pulseaudio
    pipewire
    
    # Development headers
    libpulseaudio.dev
  ];
}
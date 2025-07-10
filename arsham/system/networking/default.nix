{ 
  user, 
  lib, 
  ... 
}:

{
  imports = [
    ./vpn.nix
  #  ./hostapd.nix
  ];
  
  services = {
    blueman.enable = true;
    openssh.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  
  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  
  networking = {
    # Configure network proxy if necessary
  #  proxy.default = "http://192.168.1.120:10808";
  #  proxy.default = "http://192.168.202.53:10808";
  #  proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    wireless.enable = true;
    hostName = "${user.host}";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    interfaces.wlp2s0.useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        3216 
        3658 
        3659 
        8082 
        24800 
        47984 
        47989 
        47990 
        48010 
        2080
      ];
      
      allowedTCPPortRanges = [
        { from = 31800; to = 31899; }
        { from = 27015; to = 27030; }
        { from = 27036; to = 27037; }
      ];
      
      allowedUDPPorts = [ 
        3216 
        27036 
        48010 
      ];
      
      allowedUDPPortRanges = [
        { from = 24800; to = 24810; }
        { from = 47998; to = 48000; }
        { from = 8000; to = 8010; }
        { from = 9942; to = 9944; }
        { from = 3658; to = 3659; }
        { from = 27000; to = 27031; }
      ];
    };
  };
  
  environment.systemPackages = with pkgs; [
      # Networking Tools
      wget
      curl
      rsync
      nmap
      pssh
      tmate
      nix-prefetch-git
      iw
      networkmanagerapplet
      blueman
  ];
}

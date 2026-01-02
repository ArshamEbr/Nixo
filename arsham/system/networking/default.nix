{ 
  pkgs,
  user, 
  lib, 
  ... 
}:

{
  imports = [
    ./vpn.nix
    # ./hostapd.nix
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
    systemd-networkd-wait-online.enable = false;
  };
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  
  networking = {
    # Configure network proxy if necessary
    # proxy.default = "http://192.168.1.120:10808";
    # proxy.default = "http://192.168.202.53:10808";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    # interfaces.wlp2s0.useDHCP = lib.mkDefault true;
    # wireless.enable = false;
    hostName = "${user.host}";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
    #  wifi.backend = "iwd";
    };
  
  #  wireguard = {
  #    enable = false;
  #    interfaces = {
  #      wg0 = {
  #        ips = [ "192.168.133.2/30" ];
  #        privateKeyFile = "/home/arsham/nixo/arsham/system/networking/privatekey";
  #        listenPort = 51820;
  #        mtu = 1240;
  #        peers = [
  #          {
  #            publicKey = "GxQE2dm2LQEHsDD30M9iZxhFM3UDccjUWynWjc+mDSE=";
  #            allowedIPs = [
  #              "192.168.133.0/30"
  #              "192.168.134.0/30"
  #              "192.168.42.0/24"
  #              "10.1.1.0/24"
  #            ];
  #            endpoint = "frameshift.net:51827";
  #            persistentKeepalive = 25;
  #          }
  #        ];
  #      };
  #    };
  #  };
  
    firewall = {
      enable = true;
    #  checkReversePath = false; 
    #  trustedInterfaces = [ "wg0" ];
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
      #  51820
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
      #  51820
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
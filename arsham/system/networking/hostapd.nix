# Full-featured NixOS configuration for WiFi hotspot sharing
# Creates a WiFi repeater: connects to existing WiFi and broadcasts a hotspot
{ 
  config,
  pkgs,
  ...
}:

{
  # Create virtual interfaces for station and AP modes
  networking.wlanInterfaces = {
    "wlp2s0" = { device = "wlp2s0"; };
    "wlan-ap0" = {
      device = "wlp2s0";
      mac = "00:11:22:33:44:56"; # Optional, unique MAC
    };
  };

  # Configure station mode to connect to existing WiFi
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp2s0" ];
  networking.wireless.networks = { "ArshamAir" = { psk = "0940998866arsham"; }; };

  # Configure AP mode with hostapd
  services.hostapd = {
    enable = true;
    radios = {
      "wlan-ap0" = {
        band = "2g"; # 2.4GHz, use "5g" for 5GHz if needed
        countryCode = "IR"; # Adjust to your country
        networks = {
          "wlan-ap0" = {
            ssid = "myhotspot";
            authentication = {
              mode = "wpa2-sha1";
              wpaPassword = "hotspot_password"; # Use `passwordFile` for security
            };
            settings = {
              # Additional hostapd settings for full-featured config
              wmm_enabled = 1; # Enable WiFi Multimedia
              ieee80211n = 1; # Enable 802.11n
              ht_capab = "[HT40+][SHORT-GI-20][SHORT-GI-40]"; # HT capabilities
            };
          };
        };
      };
    };
  };

  # Assign static IP to AP interface
  networking.interfaces."wlan-ap0".ipv4.addresses = [ {
    address = "192.168.12.1";
    prefixLength = 24;
  } ];

  # DHCP Server on wlan-ap0
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wlan-ap0";
      bind-interfaces = true;
      dhcp-range = "192.168.1.100,192.168.1.200,24h";
    #  dhcp-option = [
    #    "3,192.168.1.2" # default gateway
    #    "6,8.8.8.8,8.8.4.4" # DNS servers
    #  ];
    };
  };

  # Enable NAT to share internet from wlp2s0 to wlan-ap0
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wlan-ap0" ];
    externalInterface = "wlp2s0";
  };

  # Configure firewall to allow necessary traffic
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 53 67 ];
    extraCommands = ''
      iptables -A FORWARD -i wlan-ap0 -o wlp2s0 -j ACCEPT
      iptables -A FORWARD -i wlp2s0 -o wlan-ap0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';
  };
  networking.networkmanager.unmanaged = [
    "interface-name:wlan-ap0"
  ];
  services.haveged.enable = true;
}
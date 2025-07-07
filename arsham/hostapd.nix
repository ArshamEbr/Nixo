{ config, lib, pkgs, ... }:

let
  physicalDevice = "wlan0"; # from `ip link` or `lspci -k`
  clientInterface = "wlan-station0";
  apInterface = "wlan-ap0";
  apIP = "192.168.12.1";
in {
  networking.wlanInterfaces = {
    "${clientInterface}" = { device = physicalDevice; };
    "${apInterface}" = {
      device = physicalDevice;
      mac = "08:11:96:0e:08:0a"; # optional, for interface separation
    };
  };

  # Let NetworkManager manage only the client side
  networking.networkmanager = {
    enable = true;
    unmanaged = [
      "interface-name:${physicalDevice}"
      "interface-name:${apInterface}"
    ];
  };

  networking.interfaces."${apInterface}".ipv4.addresses =
    lib.optionals config.services.hostapd.enable [{
      address = apIP;
      prefixLength = 24;
    }];

  services.hostapd = {
    enable = true;
    interface = apInterface;
    ssid = "NixOS-Hotspot";
    wpaPassphrase = "supersecure123";
    hwMode = "g"; # use "a" for 5GHz if supported
    channel = 6;
  };

  services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
    enable = true;
    extraConfig = ''
      interface=${apInterface}
      bind-interfaces
      dhcp-range=192.168.12.10,192.168.12.254,24h
    '';
  };

  networking.firewall.allowedUDPPorts = lib.optionals config.services.hostapd.enable [53 67]; # DNS, DHCP

  # Required for NAT (Internet sharing)
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;

  # Haveged provides entropy for WPA2 (optional but useful)
  services.haveged.enable = config.services.hostapd.enable;

  # Add NAT rules
  networking.nat = lib.optionalAttrs config.services.hostapd.enable {
    enable = true;
    internalInterfaces = [ apInterface ];
    externalInterface = clientInterface;
  };
}

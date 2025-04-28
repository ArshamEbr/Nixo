{ user, lib, ... }:
{
  config = {
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant F this!

    /*
    *HERE* are the Steps to manually downloading a package and pass it to the 
    nix packages storage :
    Once you have downloaded the file, please use the following
    commands and re-run the nixos-rebuild:
  
    mv $HOME/Desierd-PKG-Location $PWD/Package-name-in-nix
  
    nix-prefetch-url file://$HOME/pkgfile
  
    Alternatively, you can use the following command to download the
    file directly:
  
    nix-prefetch-url --name pkg-name https://the-link-of-the-file-to-download
    */

    networking = {
      # Configure network proxy if necessary
    #  proxy.default = "http://192.168.1.120:10808";
    #  proxy.noProxy = "127.0.0.1,localhost,internal.domain";
      hostName = "${user.host}";
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 3216 3658 3659 8082 24800 47984 47989 47990 48010 ];

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
  };
}

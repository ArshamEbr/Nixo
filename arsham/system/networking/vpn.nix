{
  pkgs,
  pkgs-stable,
  ...
}:

{
  programs = {
    clash-verge = {
      enable = true;
      package = pkgs-stable.clash-verge-rev;
      tunMode = true;
      serviceMode = true;
    };
    
    nekoray = {
      enable = true;
      tunMode = {
        enable = true;
      };
    };
  };
#  services.mihomo = {
#    enable = true;
#    tunMode = true;
#    configFile = "";
#  };
}
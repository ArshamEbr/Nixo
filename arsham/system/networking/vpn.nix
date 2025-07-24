{
  pkgs,
  ...
}:

{
  programs = {
    clash-verge = {
      enable = true;
      tunMode = true;
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
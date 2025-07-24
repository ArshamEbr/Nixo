{
  inputs, 
  ... 
}:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  #  vscode.profiles.default.enable = true;
    btop.enable = true;
  #  starship.enable = true;
    cava.enable = true;
    mpv.enable = true;
    foot.enable = true;
    yazi.enable = true;
  };
}

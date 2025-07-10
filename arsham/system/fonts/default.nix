{
  pkgs,
  ...
}:

{
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
    };

    fontDir.enable = true;
    
    packages = with pkgs; [
      nerd-fonts.space-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      fontconfig
      lexend
      material-symbols
      google-fonts
      layan-cursors
    ];
  };
}
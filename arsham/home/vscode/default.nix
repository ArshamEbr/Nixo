{ 
  pkgs,
  ... 
}:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-vscode.cpptools
      usernamehw.errorlens
      oderwat.indent-rainbow
      eamodio.gitlens
      jnoortheen.nix-ide
      platformio.platformio-vscode-ide
    ];
  };
}
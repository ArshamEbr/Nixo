{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.vscode = {
      enable = true;
      package = pkgs-unstable.vscode;
      extensions = with pkgs-unstable.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
        oderwat.indent-rainbow
        eamodio.gitlens
        jnoortheen.nix-ide
        danielsanmedium.dscodegpt
        platformio.platformio-vscode-ide
      ];
    };
  }
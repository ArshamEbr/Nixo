{ 
  pkgs,
  ... 
}:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python                 # Python language support
      ms-vscode.cpptools               # C/C++ language support
      usernamehw.errorlens             # Inline error highlighting
      oderwat.indent-rainbow           # Indentation highlighting
      eamodio.gitlens                  # Git integration and insights
      jnoortheen.nix-ide               # Nix language support
      danielsanmedium.dscodegpt        # AI code assistant
      platformio.platformio-vscode-ide # Embedded development platform
    ];
  };
}
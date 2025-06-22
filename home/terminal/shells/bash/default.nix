{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }:
  {
    programs.bash = {
      enable = true;
      package = pkgs-unstable.bashInteractive;
      enableCompletion = true;

      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:"
      '';

      shellAliases = {
      };
      
      sessionVariables = {
        EDITOR = "nano";
      };
    };
  }
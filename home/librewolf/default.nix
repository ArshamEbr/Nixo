{ inputs, pkgs, pkgs-old, pkgs-unstable, user, config, ... }:
let
  profilePath = "${config.xdg.configHome}/librewolf";
in
  {
    programs.librewolf = {
      enable = true;
      package = pkgs-unstable.librewolf;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
    home.file."${profilePath}/userChrome.css".text = ''
      @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
  
      :root {
        --toolbar-bgcolor: #1a1b26 !important;
        --toolbar-color: #c0caf5 !important;
        --urlbar-background-color: #24283b !important;
        --urlbar-color: #c0caf5 !important;
      }
  
      #navigator-toolbox {
        background-color: var(--toolbar-bgcolor) !important;
        color: var(--toolbar-color) !important;
        border: none !important;
      }
  
      #urlbar,
      #searchbar {
        background-color: var(--urlbar-background-color) !important;
        color: var(--urlbar-color) !important;
        border: none !important;
        border-radius: 6px !important;
      }
  
      .tab-background {
        background-color: transparent !important;
      }
  
      .tab-line {
        background-color: #7aa2f7 !important;
      }
  
      .tabbrowser-tab[selected] {
        background-color: #24283b !important;
        color: #c0caf5 !important;
      }
  
      .tabbrowser-tab:not([selected]):hover {
        background-color: #292e42 !important;
      }
    '';
  }
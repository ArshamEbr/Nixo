{ lib, config, ... }:

let
  inherit (lib) types mkOption mapAttrsToList replaceStrings concatStringsSep;
  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    username = mkOption {
      type = types.str;
      description = "Username for dotfiles";
    };
    files = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          text = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          source = mkOption {
            type = types.nullOr types.path;
            default = null;
          };
        };
      });
      default = {};
    };
  };

  config = lib.mkIf (cfg != {}) {
    environment.etc = lib.mkMerge (
      mapAttrsToList (target: val: {
        "dotfiles/${replaceStrings ["/"] ["__"] target}" = 
          if val.text != null then { text = val.text; }
          else { source = val.source; };
      }) cfg.files
    );

    system.activationScripts.linkDotfiles = {
      text = ''
        set -e
        echo "Linking dotfiles..."
        ${concatStringsSep "\n" (mapAttrsToList (target: val: ''
          mkdir -p "/home/${cfg.username}/$(dirname "${target}")"
          ln -sf "/etc/dotfiles/${replaceStrings ["/"] ["__"] target}" \
            "/home/${cfg.username}/${target}"
        '') cfg.files)}
      '';
    };
  };
}
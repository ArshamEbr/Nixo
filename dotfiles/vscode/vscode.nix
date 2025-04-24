{ pkgs, config, lib, user, pkgs-unstable, ... }:
let
  vscode_extand = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      ms-python.python
      oderwat.indent-rainbow
      eamodio.gitlens
      jnoortheen.nix-ide
      danielsanmedium.dscodegpt
    ];
  };
in
{

#  dotfiles = {
#      username = "${user.name}";
#      files = {
#      ".config/rofi/config.rasi".text = ''
#      '';
#      };
#  };
    environment.systemPackages = with pkgs-unstable; [
      vscode_extand
    ];
  }

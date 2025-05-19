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
    users.users.${user.name}.packages = with pkgs-unstable; [
      vscode_extand
    ];
  }

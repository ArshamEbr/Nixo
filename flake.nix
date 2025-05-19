{
  description = "Nixo >:)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    anyrun.url = "github:Kirottu/anyrun";
    nix-gl-host.url = "github:numtide/nix-gl-host";
    nixgl.url = "github:nix-community/nixGL";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dream2nix.url = "github:nix-community/dream2nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://anyrun.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs@{ 
    nixpkgs,
    nixpkgs-old,
    nixpkgs-unstable,
    anyrun,
    dream2nix,
    nixgl,
    nix-gl-host,
    nix-vscode-extensions,
    nixos-hardware,
    ...
  }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs-old = import inputs.nixpkgs-old {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };
    pkgs-devshell = import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };
    user = {
      name = "arsham"; # TODO Change it to your own!
      host = "Nixo";   # TODO Change it to your own!
    };
  in {
    nixosConfigurations = {
      ${user.host} =
      let
      pkgs = import inputs.nixpkgs rec {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "vscode" "discord" "steam" "steam-original" "steam-run"
          ];
          permittedInsecurePackages = [
            "python-2.7.18.7"
            "openssl-1.1.1w"
            "archiver-3.5.1"
          ];
        };
        overlays = [
          nixgl.overlay
          (import ./overlays/debugpy.nix)
          (import ./overlays/freerdp.nix)
          (import ./overlays/materialyoucolor.nix)
          (import ./overlays/wofi-calc.nix)
        ];
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
          permittedInsecurePackages = [
            "python-2.7.18.7"
            "openssl-1.1.1w"
            "archiver-3.5.1"
          ];
        };
      };
      in 
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit pkgs;
          inherit pkgs-unstable;
          inherit inputs;
          inherit pkgs-old;
          inherit user;
        };
        system.packages = [ 
          anyrun.packages.${system}.anyrun
          nix-gl-host.defaultPackage.x86_64-linux
          nixgl.defaultPackage.x86_64-linux
        ];
        modules = [
          ./config.nix
          ./hardware.nix
          ./arsham
          ./dotfiles
        ];
      };
    };
  };
}

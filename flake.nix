{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    anyrun.url = "github:Kirottu/anyrun";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #anyrun.inputs.nixpkgs.follows = "nixpkgs";
    nix-gl-host.url = "github:numtide/nix-gl-host";
    nixgl.url = "github:nix-community/nixGL";
    #ags.url = "github:Aylur/ags/main";
    ags.url = "github:gorsbart/ags";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dream2nix.url = "github:nix-community/dream2nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-old, nixpkgs-unstable, anyrun, home-manager, dream2nix, nixgl, nix-gl-host, nix-vscode-extensions, nixos-hardware, ... }:
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

  in {
    nixosConfigurations = {
      rand =
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
          ];
        };
        overlays = [
          nixgl.overlay
          (import ./overlays/debugpy.nix)
          (import ./overlays/freerdp.nix)
          (import ./overlays/materialyoucolor.nix)
          (import ./overlays/end-4-dots.nix)
          (import ./overlays/wofi-calc.nix)
        ];
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
      };
      in 
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit pkgs;
          inherit pkgs-unstable;
        };
        system.packages = [ anyrun.packages.${system}.anyrun
                            nix-gl-host.defaultPackage.x86_64-linux
                            nixgl.defaultPackage.x86_64-linux
                          ];
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./rand/boot.nix
          ./rand/graphics.nix
          ./rand/networking.nix
          ./rand/virtualisation.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { 
              inherit inputs;
              inherit pkgs-unstable;
              inherit pkgs-old;
            };
            home-manager.users.arsham = import ./home.nix;
          }
        ];
      };
  };
};
}

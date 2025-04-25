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
            "archiver-3.5.1" ####
          ];
        };
        overlays = [
          nixgl.overlay
          (import ./overlays/debugpy.nix)
          (import ./overlays/freerdp.nix)
          (import ./overlays/materialyoucolor.nix)
        #  (import ./overlays/end-4-dots.nix)
          (import ./overlays/wofi-calc.nix)

        #  (self: super: {
        #    electron = super.electron.overrideAttrs (old: {
        #      NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE or "" + " -march=native -O2 ";
        #    });
        #  })

        #  (self: super: {
        #    electron = super.electron.overrideAttrs (old: {
        #      NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE or "" + " -march=native -O2 ";
        #    });
        #  })

        #  (self: super: {
        #      gcc = super.gcc.overrideAttrs (old: {
        #        NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE or "" + " -march=native -O2 ";
        #      });
        #      llvm = super.llvm.overrideAttrs (old: {
        #        NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE or "" + " -march=native -O2 ";
        #      });
        #  })
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
          inherit inputs;
          inherit pkgs-old;
          inherit user;
        };
        system.packages = [ anyrun.packages.${system}.anyrun
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

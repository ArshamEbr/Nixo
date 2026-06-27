{
  description = "Nixo >:)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.11";
    nix-gl-host.url = "github:numtide/nix-gl-host";
    nixgl.url = "github:nix-community/nixGL";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dream2nix.url = "github:nix-community/dream2nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nur.url = "github:nix-community/NUR";
    catppuccin.url = "github:catppuccin/nix";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    frostix = {
      url = "github:shomykohai/frostix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
  #    "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  outputs = inputs@{ 
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-old,
    home-manager,
    dream2nix,
    nixgl,
    nix-gl-host,
    nix-vscode-extensions,
    nixos-hardware,
    catppuccin,
    nur,
    frostix,
    ...
  }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    frostixPkgs = inputs.frostix.packages.${system};
    pkgs-old = import inputs.nixpkgs-old {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };
    
    pkgs-devshell = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };
    
    pkgs-stable = import nixpkgs-stable {
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
      in
      nixpkgs.lib.nixosSystem {
        modules = [
          ./arsham/system/system.nix
          
          {
            _module.args = {
              inherit inputs;
              inherit pkgs-old;
              inherit user;
            };
            
            nixpkgs.hostPlatform = system;
            
            nixpkgs.overlays = [
              nur.overlays.default
              (import ./overlays/debugpy.nix)
              (import ./overlays/freerdp.nix)
              (import ./overlays/materialyoucolor.nix)
              (import ./overlays/wofi-calc.nix)
            ];
            
            nixpkgs.config = {
              allowUnfree = true;
              allowBroken = true;
              allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
                "vscode" "discord" "steam" "steam-original" "steam-run"
              ];
              permittedInsecurePackages = [
                "python-2.7.18.7"
                "openssl-1.1.1w"
                "archiver-3.5.1"
                "ventoy-1.1.12"
                "nodejs-20.20.2"
                "nodejs-slim-20.20.2"
              ];
            };
          }
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { 
              inherit inputs;
              inherit pkgs-old;
              inherit pkgs-stable;
              inherit user;
              frostix = frostixPkgs;
            };
            home-manager.users.${user.name} = {
              imports = [
                ./arsham/home/home.nix
                inputs.caelestia-shell.homeManagerModules.default
              ];
            };
          }
        ];
      };
    };
  };
}
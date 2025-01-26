{ pkgs, pkgs-unstable, config, ... }:
{
  # Enable unfree packages and CUDA support
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  # Add necessary packages to system-wide environment
  environment.systemPackages = with pkgs; [
    glib
    python312
    python312Packages.accelerate
    python312Packages.torchWithCuda
    python312Packages.torchsde
    python312Packages.torchvision
    python312Packages.torchaudio
    python312Packages.einops
    python312Packages.transformers
    python312Packages.safetensors
    python312Packages.aiohttp
    python312Packages.pyyaml
    python312Packages.pillow
    python312Packages.scipy
    python312Packages.tqdm
    python312Packages.psutil
    (python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
    ]))
  ];

  # Set environment variables for library paths
  environment.variables.LD_LIBRARY_PATH = "${pkgs.glib}/lib";

   nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

}

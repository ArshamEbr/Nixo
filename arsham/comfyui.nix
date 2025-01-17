let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };
in pkgs.mkShell {
  buildInputs = with pkgs; [
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
  ];
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [
      pkgs.glib
      python-pkgs.pandas
      python-pkgs.requests
    ]))
  ];
  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.glib.out}/lib";
}

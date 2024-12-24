# NixOS for Squid

## Installation
1. Download https://channels.nixos.org/nixos-24.05/latest-nixos-minimal-x86_64-linux.iso
1. dd to thumbdrive `sudo dd if=nixos-t2-iso-minimal.iso of=/dev/sdX status=progress` 
1. boot the system from the thumbdrive
1. `nix-shell -p git`
1. `git clone https://github.com/celesrenata/nix-flakes-rand --branch intel`
1. `cd nix-flakes-rand`
1. `sudo ./setup`
1. `reboot`
# Nixo

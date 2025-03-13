{ pkgs, pkgs-unstable, config, ... }:
{
  imports = [./hardware.nix]; # Include the results of the hardware scan.

  nix = {
  #  optimise.automatic = true; # Garbage Collector
    settings = {
      max-jobs = "auto";  # Uses all available CPU cores
      cores = 4; 
      experimental-features = [ "nix-command" "flakes" ]; # Enable Flakes.
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };

  zramSwap.enable = true;
  nixpkgs.config.allowUnfree = true; # Licences
  security.rtkit.enable = true;

  hardware = {

    enableAllFirmware = true;
    uinput.enable = true; # Udev rules
    pulseaudio.enable = false; # Disable PulseAudio

    bluetooth = { # Enable Bluetooth
      enable = true;
      powerOnBoot = true;
    };

  };

  
  #location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran"; # yea...Iran...sigh.....

  
  i18n = { # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fa_IR/UTF-8" ]; 
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {

    #automatic-timezoned.enable = true;
    openssh.enable = true; # Openssh daemon
    dbus.enable = true; # Related to kde polkit     
    geoclue2.enable = true; # Enable Location 
    acpid.enable = true; # Enable acpid
    gnome.gnome-keyring.enable = true; # Gnome Keyring
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager)
    touchegg.enable = true; # Gestures
    udisks2.enable = true;
    blueman.enable = true; # Bluetooth 
    gvfs.enable = true;

  # openvpn.servers = {
  #   homeVPN    = { config = '' config /home/arsham/Downloads/Usa.ovpn ''; };
  # };

    displayManager = { # Auto login feature to use hyprlock instead
      autoLogin.enable = true;
      autoLogin.user = "arsham";
      defaultSession = "hyprland";
    };

    xserver = {
      enable = true;  # Enable the X11 windowing system
      displayManager.gdm.enable = true; # Enable the GDM Display Manager
        xkb = { # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };

    udev = {
      enable = true;
      packages = [ 
        pkgs.libmtp 
        pkgs.libinput 
      ];
      extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="arsham", GROUP="qemu-libvirtd", MODE="0666"
      '';
    };

    printing = {
      enable = true; # Enable CUPS to print documents.
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };

   # jack = {
   #   jackd.enable = true;
   #   alsa.enable = false; # support ALSA only programs via ALSA JACK PCM plugin
   #   loopback = { # support ALSA only programs via loopback device (supports programs like Steam)
   #     enable = true;
   #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
   #     #dmixConfig = ''
   #     #  period_size 2048
   #     #'';
   #   };
   # };

  };

  programs = { 

    hyprland = { # Best Window Manager
      enable = true;
      package = pkgs-unstable.hyprland;
      xwayland.enable = true; # Whether to enable Xwayland
    };

    fish = {
      enable = true;
    };

    nh = { # A better nixos-rebuild version
      enable = true;
      flake = "/home/arsham/nixo";
      clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 3";};
    };

  };
 
  fonts.packages = with pkgs-unstable; [ # Enable Fonts.
    nerd-fonts.space-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    fontconfig
    lexend
    material-symbols
    bibata-cursors
    google-fonts
  ];
  
  users.groups = { # Extra Groups
    mlocate = {};
    plocate = {};
    libvirt = {};
    kvm = {};
  };

  security.sudo.configFile = ''
    root   ALL=(ALL:ALL) SETENV: ALL
    %wheel ALL=(ALL:ALL) SETENV: ALL
    arsham  ALL=(ALL:ALL) SETENV: ALL
  '';
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arsham = {
    isNormalUser = true;
    description = "Arsham";
    extraGroups = [ "networkmanager" "scanner" "lp" "wheel" "input" "uinput" "render" "video" "audio" "docker" "libvirt" "libvirtd" "kvm" "virsh" ];
    packages = with pkgs; [
      firefox
      thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # Enable Wayland for Electron.
  environment = {
    localBinInPath = true;
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";

    # $ nix search wget
    systemPackages = with pkgs; [
      # Minecraft
      libnotify
      prismlauncher

      # Editors
      vim
      nano

      # Some auto mount stuff for mtp
      gvfs
      jmtpfs
      android-udev-rules
      libmtp
      glib
 
      # Networking Tools
      wget
      curl
      rsync
      nmap
      pssh
      tmate
      nix-prefetch-git

      # Audio.
      ladspaPlugins
      calf
      lsp-plugins
      easyeffects
      alsa-utils

      # Sound
      libspatialaudio
      pulseaudio
      pipewire

      # System Tools.
      glxinfo
      blueman
      networkmanagerapplet
      nix-index
      mlocate
      util-linux
      openssl
      btop
      nvtopPackages.full
      usbutils
      pciutils
      thefuck
      tldr
      bc
      freerdp3Override
      kbd
      imagemagick
      sunshine
      android-tools
      remmina

      # Shells.
      fish # My fav
      zsh
      bash

      # Development Tools.
      git
      nodejs_20
      meson
      gcc14
      cmake
      pkg-config
      glib.dev
      glib
      glibc.dev
      gobject-introspection.dev
      pango.dev
      harfbuzz.dev
      cairo.dev
      gdk-pixbuf.dev
      atk.dev
      libpulseaudio.dev
      typescript
      ninja
      node2nix
      nil
      sublime4
      gnumake

      # Session.
      polkit
      polkit_gnome
      dconf
      killall
      gnome-keyring
      wayvnc
      evtest
      zenity
      linux-pam
      cliphist
      sudo
      xwaylandvideobridge
      polkit-kde-agent
      kdePackages.kde-cli-tools

      # Wayland.
      xdg-desktop-portal-hyprland
      xwayland
      brightnessctl
      ydotool
      fcitx5
      wlsunset
      wtype
      wl-clipboard
      xorg.xhost
      wev
      wf-recorder
      ffmpeg-full
      mkvtoolnix-cli
      vulkan-tools
      libva-utils
      wofi
      libqalculate
      sunshine 
      moonlight-qt
      xfce.thunar
      wayland-scanner
      waypipe
      libva
      libva-utils

      # GTK
      gtk3
      gtk3.dev
      libappindicator-gtk3.dev
      libnotify.dev
      gtk4
      gtk4.dev
      gjs
      gjs.dev
      gtksourceview
      gtksourceview.dev
      xdg-desktop-portal-gtk

      # Not GTK.
      tk
  
      # Terminals.
      kitty
      foot

      # Emulation
      wine
      wine64
      qemu
  
      # Camera
      libcamera
      
      # Shared Dir
      virtiofsd /*
       Doing the Steps below is mandatory for sharing the dir with windows vm after installing the virtiofsd in linux :
       use the "which virtiofsd" command inside terminal and copy the output in 
       here : "<binary path="OUTPUT_HERE"/>"
       Then add the Filesystem in virt-manager from add hardware section and 
       copy the text above in xml section of that for example:
       #################################################################################
       <filesystem type="mount" accessmode="passthrough">
         <driver type="virtiofs"/>
         <binary path="/etc/profiles/per-user/arsham/bin/virtiofsd"/> #THIS RIGHT HERE!
         <source dir="/home/arsham/"/>
         <target dir="Home"/>
         <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
       </filesystem>
       ##############################################################################
       Download and install latest WinFSP inside your windows vm
       also dont forget to set the VirtIO-FS Service to start automaticly inside services
      */
    ];
  };

  system.stateVersion = "24.11";
}

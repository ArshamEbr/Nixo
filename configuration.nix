# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, pkgs-unstable, ... }:
{
  # Licences.
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      #"${pkgs-unstable}/nixos/modules/programs/alvr.nix"
      ./hardware-configuration.nix
    ];

  environment.localBinInPath = true;
  # Enable Flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;
  boot.plymouth.enable = true;
  # Use the Grub EFI boot loader.

  # Udev rules.
  hardware.uinput.enable = true;

  # Set your time zone.

  #services.automatic-timezoned.enable = true;
  #location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "fa_IR/UTF-8" ]; 
  i18n.extraLocaleSettings = {
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

  # Enable the GDM Display Manager.
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "arsham";
  services.displayManager.defaultSession = "hyprland";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Enlightenment Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    package = pkgs-unstable.hyprland;
    # Whether to enable Xwayland
    xwayland.enable = true;
  };
 
  programs.fish = {
    enable = true;
  };
  # Enable Location.
  services.geoclue2.enable = true;

  # Enable acpid
  services.acpid.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };

  # Enable Fonts.
  fonts.packages = with pkgs-unstable; [
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
  ];

  # Extra Groups
  users.groups.mlocate = {};
  users.groups.plocate = {};
  users.groups.libvirt = {};
  users.groups.kvm = {};

  security.sudo.configFile = ''
    root   ALL=(ALL:ALL) SETENV: ALL
    %wheel ALL=(ALL:ALL) SETENV: ALL
    arsham  ALL=(ALL:ALL) SETENV: ALL
  '';

  # services.keyd = {
  #   enable = true;
  #   keyboards.mac.settings = {
  #     main = {
  #       control = "layer(meta)";
  #       meta = "layer(control)";
  #       rightcontrol = "layer(meta)";
  #     };
  #     meta = {
  #       left =  "control-left";
  #       right = "control-right";
  #       space = "control-space";
  #     };
  #   };
  #   keyboards.mac.ids = [
  #     "*"
  #   ];
  # };

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Gestures.
  services.touchegg.enable = true;

  # Garbage Collection.
  nix.optimise.automatic = true;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arsham = {
    isNormalUser = true;
    description = "Arsham";
    extraGroups = [ "networkmanager" "scanner" "lp" "wheel" "input" "uinput" "render" "video" "audio" "docker" "libvirt" "kvm" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # Enable Wayland for Electron.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Editors.
    vim
    nano
    udiskie
    gvfs
    jmtpfs
    #warp-plus
 
    # Secure Boot Suppoert
    #sbctl
 
    # Networking Tools.
    wget
    curl
    rsync
    nmap
    pssh
    tmate

    # Audio.
    ladspaPlugins
    calf
    lsp-plugins
    easyeffects
    alsa-utils

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
    fish
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

    # Wayland.
    xdg-desktop-portal-hyprland
    xwayland
    brightnessctl
    ydotool
    swww
    hyprpaper
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

    # Mac Sound.
    libspatialaudio
    pulseaudio
    pipewire
    #t2AppleAudioDSP

    # Mac Camera.
    libcamera
  ];

    programs.nh = {
      enable = true;
      flake = "/home/arsham/nixo";
      clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 3";};
      };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

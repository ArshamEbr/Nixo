{ pkgs, pkgs-unstable, config, lib, user, ... }:
{
  imports = [./hardware.nix];

  nix = {
    optimise.automatic = true; # Garbage Collector
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      max-jobs = 8; # TODO change it to your cpu core count
      cores = 8; # TODO change it to your cpu core count

      experimental-features = [ 
        "nix-command" 
        "flakes" 
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

#  systemd.services.nix-daemon.environment = {
#    https_proxy = "socks5h://localhost:7891";
#    https_proxy = "http://localhost:7890"; # or use http prctocol instead of socks5
#  };
  
  zramSwap.enable = true;
  nixpkgs.config.allowUnfree = true; # Licences

  hardware = {
    enableAllFirmware = true;
    uinput.enable = true; # Udev rules
    pulseaudio.enable = false; # Disable PulseAudio

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  
  location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran"; # yea...Iran...sigh..... # TODO change to your location

  
  i18n = { # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fa_IR/UTF-8" ];  # TODO change to your location
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

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  services = {
    openssh.enable = true;
    dbus.enable = true;
    acpid.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    touchegg.enable = true;
    udisks2.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    fstrim.enable = true;
    geoclue2.enable = true;

    getty = {
      autologinUser = "${user.name}";
    };
    
    udev = {
      enable = true;

      packages = [ 
        pkgs.libmtp 
        pkgs.libinput 
      ];

      extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="${user.name}", GROUP="qemu-libvirtd", MODE="0660"
      '';
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

  };

  programs = {

    ccache.enable = true;
    adb.enable = true;

    nix-ld = {
      enable = true;
      
      libraries = with pkgs; [
        bash
        stdenv.cc.cc
        glibc
        zlib
        xorg.libX11
        xorg.libXext
        xorg.libXtst
        xorg.libXi
        xorg.libXrender
        xorg.libXrandr
        xorg.libXcursor
        xorg.libXfixes
        xorg.libXdmcp
        fontconfig
      ];
    };

    nh = {
      enable = true;
      flake = "/home/${user.name}/nixo";

      clean = {
        enable = false;
        dates = "weekly";
        extraArgs = "--keep 3";
      };
    };

  };

  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
    };

    fontDir.enable = true;
    
    packages = with pkgs-unstable; [
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
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    sudo.configFile = ''
      root   ALL=(ALL:ALL) SETENV: ALL
      %wheel ALL=(ALL:ALL) SETENV: ALL
      ${user.name}  ALL=(ALL:ALL) SETENV: ALL
    '';
  };

  users = { # Don't forget to set a password with ‘passwd’.
    groups = {
      mlocate = {};
      plocate = {};
      libvirt = {};
      kvm = {};
    };
    users.${user.name} = {
      isNormalUser = true;
      description = "${user.name}";

      extraGroups = [ 
        "networkmanager"
        "scanner"
        "lp"
        "wheel"
        "input"
        "uinput"
        "render"
        "video"
        "audio"
        "docker"
        "libvirt"
        "libvirtd"
        "kvm"
        "virsh"
      ];
    };
  };

  environment = {
    localBinInPath = true;
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    systemPackages = 
    (with pkgs; [
      # Specify the pkg names (stable)
      freerdp3Override
    ])

    ++

    (with pkgs-unstable; [
      # Specify the pkg names (latest stable)
      
      inotify-tools
      xorg.xinit
      e2fsprogs
      proot
      nixos-generators

      # FTDI
      libftdi1

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
      kbd
      imagemagick
      sunshine
      android-tools
      remmina
      libnotify

      # EFI and UKI related
      efibootmgr
      binutils
      systemdUkify

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
      zulu23

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
    #  xwaylandvideobridge
      kdePackages.xwaylandvideobridge
      libsForQt5.xwaylandvideobridge
    #  polkit-kde-agent
      kdePackages.polkit-kde-agent-1
      libsForQt5.polkit-kde-agent
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

      tk

      qemu
      libcamera
      virtiofsd
    ]);

  };

  system.stateVersion = "24.11";
}

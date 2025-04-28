{ pkgs, pkgs-unstable, config, lib, user, ... }:
{
  imports = [./hardware.nix];

  nix = {
  #  optimise.automatic = true; # Garbage Collector
    settings = {
      max-jobs = 8; # TODO change it to your cpu core count
      cores = 8; # TODO change it to your cpu core count
      experimental-features = [ "nix-command" "flakes" ]; # Enable Flakes.
    #  substituters = [
    #    "https://nix-community.cachix.org"
    #    "https://cache.nixos.org/"
    #  ];
    #  trusted-public-keys = [
    #    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    #  ];
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

  
  #location.provider = "geoclue2";
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
  # seatd.enable = true;
  # automatic-timezoned.enable = true;
  # geoclue2.enable = true; # Enable Location 

    getty = {
      autologinUser = "${user.name}"; # tty auto login to use hyprlock
    };
    
    udev = {
      enable = true;
      packages = [ 
        pkgs.libmtp 
        pkgs.libinput 
      ];
      extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="${user.name}", GROUP="qemu-libvirtd", MODE="0666"
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
    nix-ld.enable = true;
    fish.enable = true;
    
    bash = {
      shellAliases = {
      hyprxd = "dbus-run-session Hyprland";
      hyproxd = "exec uwsm start Hyprland";
      firexd = "dbus-run-session wayfire";
      fireoxd = "exec uwsm start wayfire";
      };
    #  loginShellInit = ''
    #    if uwsm check may-start && uwsm select; then
    #      exec uwsm start default
    #    fi
    #  '';
    };

    nh = {
      enable = true;
      flake = "/home/${user.name}/nixo";

      clean = {
        enable = true;
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

  # Don't forget to set a password with ‘passwd’.
  users = {
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

  # Enable Wayland for Electron.
  environment = {
    localBinInPath = true;
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    systemPackages = 
    (with pkgs; [
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
      freerdp3Override
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

      tk  
      kitty
      qemu
      libcamera
      virtiofsd
    ])

    ++

    (with pkgs-unstable; [
    ]);

  };

  system.stateVersion = "24.11";
}

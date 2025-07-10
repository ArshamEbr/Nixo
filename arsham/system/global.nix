{ 
  pkgs, 
  pkgs-stable,
  user, 
  ... 
}:

{
  nix = {
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      max-jobs = 8;              # TODO change it to your cpu core count
      cores = 8;                 # TODO change it to your cpu core count
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
  
  zramSwap.enable = true;
  nixpkgs.config.allowUnfree = true;
  
  hardware = {
    enableAllFirmware = true;
    uinput.enable = true;
  };
  
  
  location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran"; # yea...Iran...sigh.....      # TODO change to your location
  
  
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
  
  services = {
    dbus.enable = true;
    acpid.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    touchegg.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    fstrim.enable = true;
    geoclue2.enable = true;
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
  };
  
  programs = {
    hyprland.enable = true;
    ccache.enable = true;
    adb.enable = true;
    bash = {
      shellAliases = {
      hyprxd = "dbus-run-session Hyprland";
      hyproxd = "exec uwsm start default";
      };
    };
    
    steam = {
      enable = true;
    #  extest.enable = true;
    };
    
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
        "dialout"
      ];
    };
  };
  
  system.stateVersion = "24.11";
  
  environment = {
    localBinInPath = true;
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.MOZ_ENABLE_WAYLAND = "1";
    systemPackages = 
    (with pkgs-stable; [
      # Specify the pkg names (stable)
    ])
    
    ++
    
    (with pkgs; [
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
      
      # System Tools.
      glxinfo
      nix-index
      mlocate
      util-linux
      openssl
      btop
      nvtopPackages.full
      usbutils
      pciutils
      pay-respects ## thefuck
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
      kdePackages.xwaylandvideobridge
      kdePackages.polkit-kde-agent-1
      kdePackages.kde-cli-tools
      freerdp3Override
      
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
      libcamera
    ]);
  };
}

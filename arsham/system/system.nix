{ 
  pkgs, 
  pkgs-stable,
  user,
  lib,
  ... 
}:

{
  imports = [
    ./audio
    ./dm
    ./fonts
    ./hardware
    ./networking
    ./power
    ./scripts
    ./virt
  ];
  
  nix = {
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };
  
  zramSwap.enable = true;
  
  hardware = {
    enableAllFirmware = true;
    uinput.enable = true;
  };
  
  location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran"; # TODO: Change to your location
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fa_IR/UTF-8" ]; # TODO: Change to your location
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

  systemd = {
    services.tailscaled.wantedBy = lib.mkForce [ ];
    timers.tailscaled-delayed = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "15s";
        Unit = "tailscaled.service";
      };
    };
  };
  
  services = {
    dbus.enable = true;
    acpid.enable = true;
    fstrim.enable = true;
    geoclue2.enable = true;
  #  tailscale.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    udisks2.enable = true;
    vnstat.enable = true;
    gvfs.enable = true;
    
    udev = {
      enable = true;
      packages = [ 
        pkgs.libmtp
        pkgs.libinput
        pkgs.stlink
        pkgs.openocd
      ];
      
      extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="${user.name}", GROUP="qemu-libvirtd", MODE="0600"
      '';
    };
    
    printing = {
      enable = true;
      drivers = with pkgs; [ 
        gutenprint
        hplipWithPlugin
      ];
    };
  };
  
  programs = {
    hyprland.enable = true;
    ccache.enable = true;
    
    bash.shellAliases = {
      hyprxd = "dbus-run-session Hyprland";
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
        file
        cpio
        gzip
        xz
        lzop
        bzip2
        lz4
        perl
        which
        findutils
        coreutils
      ];
    };
    
    nh = {
      enable = true;
      flake = "/home/${user.name}/nixo";
      clean = {
        enable = false;
        dates = "monthly";
        extraArgs = "--keep 10";
      };
    };
  };
  
  security = {
    rtkit.enable = true;
    polkit = { 
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
      
          if (
            (subject.isInGroup("wheel") || subject.isInGroup("networkmanager")) &&
            action.id == "org.freedesktop.NetworkManager.wifi.scan"
          ) {
            return polkit.Result.YES;
          }
          
          if (
            (subject.isInGroup("wheel") || subject.isInGroup("networkmanager")) &&
            action.id == "org.freedesktop.NetworkManager.enable-disable-wifi"
          ) {
            return polkit.Result.YES;
          }
          
          if ((subject.isInGroup("wheel") || subject.isInGroup("networkmanager")) &&
              action.id == "org.freedesktop.NetworkManager.network-control") {
            return polkit.Result.YES;
          }
          
          if ((subject.isInGroup("wheel") || subject.isInGroup("networkmanager")) &&
              action.id == "org.freedesktop.NetworkManager.enable-disable-network") {
            return polkit.Result.YES;
          }
          
          if (action.id == "org.libvirt.unix.manage" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
          
          if (subject.isInGroup("wheel") && (
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions"
          )) {
            return polkit.Result.YES;
          }
          
          if (subject.isInGroup("wheel")) {
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
    
    sudo.configFile = ''
      root   ALL=(ALL:ALL) SETENV: ALL
      %wheel ALL=(ALL:ALL) SETENV: ALL
      ${user.name}  ALL=(ALL:ALL) SETENV: ALL
    '';
    
    wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };
  };
  
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
        "dialout"
        "adbusers"
      ];
    };
  };
  
  system.stateVersion = "24.11";
  
  environment = {
    localBinInPath = true;
    
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    
    systemPackages = 
      (with pkgs-stable; [
        # Add stable packages here if needed
      ])
      ++
      (with pkgs; [
        # Core utilities
        inotify-tools
        e2fsprogs
        util-linux
        openssl
        kbd
        killall
        sudo
        expect
        
        # System monitoring
        btop
        nvtopPackages.full
        mesa-demos
        usbutils
        pciutils
        
        # File tools
        mlocate
        nix-index
        
        # Editors & basic tools
        vim
        nano
        bc
        tldr
        pay-respects
        imagemagick
        
        # Development
        git
        nodejs_20
        meson
        cmake
        ninja
        gnumake
        pkg-config
        gcc14
        typescript
      #  node2nix
        nil
        sublime4
        zulu
        
        # Development libraries
        glib.dev
        glibc.dev
        gobject-introspection.dev
        pango.dev
        harfbuzz.dev
        cairo.dev
        gdk-pixbuf.dev
        atk.dev
        
        # Hardware & device support
        libftdi1
        gvfs
        jmtpfs
        libcamera
        libinput-gestures
        
        # Boot & system management
        efibootmgr
        binutils
        systemdUkify
        proot
        nixos-generators
        keepassxc
        
        # Wayland & desktop
        xwayland
        wayland-scanner
        waypipe
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        brightnessctl
        ydotool
        wtype
        wl-clipboard
        evtest
        wev
        wlsunset
        fcitx5
        wofi
        libqalculate
        
        # Multimedia & streaming
        wf-recorder
        ffmpeg-full
        mkvtoolnix-cli
        sunshine
        moonlight-qt
        remmina
        wayvnc
        vulkan-tools
        libva
        libva-utils
        v2rayn
        
        # GTK libraries
        gtk3.dev
        libappindicator-gtk3.dev
        libnotify.dev
        gtk4.dev
        gjs.dev
        gtksourceview.dev
        tk
        
        # System integration
        polkit
        polkit_gnome
        kdePackages.polkit-kde-agent-1
        dconf
        gnome-keyring
        linux-pam
        cliphist
        zenity
        xfce.thunar
        xorg.xinit
        xorg.xhost
      ]);
  };
}

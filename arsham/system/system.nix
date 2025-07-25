{ 
  pkgs, 
  pkgs-stable,
  user, 
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
  
  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  nix = {
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
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
  
  # ============================================================================
  # SYSTEM CONFIGURATION
  # ============================================================================
  zramSwap.enable = true;
  nixpkgs.config.allowUnfree = true;
  
  hardware = {
    enableAllFirmware = true;
    uinput.enable = true;
  };
  
  # ============================================================================
  # LOCALIZATION & TIME
  # ============================================================================
  location.provider = "geoclue2";
  time.timeZone = "Asia/Tehran"; # TODO: Change to your location
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fa_IR/UTF-8" ];  # TODO: Change to your location
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
  
  # ============================================================================
  # SYSTEM SERVICES
  # ============================================================================
  services = {
    # Core system services
    dbus.enable = true;
    acpid.enable = true;                    # ACPI daemon for power events
    fstrim.enable = true;                   # SSD TRIM support
    geoclue2.enable = true;                 # Location services
    
    # Desktop services
    gnome.gnome-keyring.enable = true;      # Credential storage
    libinput.enable = true;                 # Input device management
    touchegg.enable = true;                 # Touchpad gestures
    udisks2.enable = true;                  # Automatic disk mounting
    gvfs.enable = true;                     # Virtual filesystem (for file managers)
    
    # Hardware management
    udev = {
      enable = true;
      packages = [ 
        pkgs.libmtp                         # MTP device support (Android, etc.)
        pkgs.libinput                       # Input device support
      ];
      
      extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="${user.name}", GROUP="qemu-libvirtd", MODE="0660"
      '';
    };
    
    # Printing
    printing = {
      enable = true;
      drivers = with pkgs; [ 
        gutenprint                          # High-quality printer drivers
        hplipWithPlugin                     # HP printer support
      ];
    };
  };
  
  # ============================================================================
  # SYSTEM PROGRAMS
  # ============================================================================
  programs = {
    # Desktop environment
    hyprland.enable = true;                 # Wayland compositor
    
    # Development tools
    ccache.enable = true;                   # Compiler cache for faster builds
    adb.enable = true;                      # Android Debug Bridge
    
    # Shell configuration
    bash = {
      shellAliases = {
        hyprxd = "dbus-run-session Hyprland";
      };
    };
    
    # Gaming
    steam = {
      enable = true;
    #  extest.enable = true;                # Uncomment for Steam Input support
    };
    
    # Dynamic linking for non-NixOS binaries
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
    
    # NixOS Helper
    nh = {
      enable = true;
      flake = "/home/${user.name}/nixo";
      clean = {
        enable = false;                     # Disabled automatic cleanup
        dates = "weekly";
        extraArgs = "--keep 3";
      };
    };
  };
  
  # ============================================================================
  # SECURITY & PERMISSIONS
  # ============================================================================
  security = {
    rtkit.enable = true;                    # Real-time permissions for audio
    polkit.enable = true;                   # Privilege escalation framework
    
    # Sudo configuration
    sudo.configFile = ''
      root   ALL=(ALL:ALL) SETENV: ALL
      %wheel ALL=(ALL:ALL) SETENV: ALL
      ${user.name}  ALL=(ALL:ALL) SETENV: ALL
    '';
    
    # Sunshine streaming server wrapper
    wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };
  };
  
  # ============================================================================
  # USER MANAGEMENT
  # ============================================================================
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
        "networkmanager"                   # Network configuration
        "scanner"                          # Scanner access
        "lp"                               # Printer access
        "wheel"                            # Sudo privileges
        "input"                            # Input device access
        "uinput"                           # User input device creation
        "render"                           # GPU rendering
        "video"                            # Video device access
        "audio"                            # Audio device access
        "docker"                           # Docker container management
        "libvirt"                          # Virtualization
        "libvirtd"                         # Virtualization daemon
        "kvm"                              # Kernel Virtual Machine
        "virsh"                            # Virtual machine shell
        "dialout"                          # Serial port access
        "adbusers"                         # Android Debug Bridge
      ];
    };
  };
  
  system.stateVersion = "24.11";
  
  # ============================================================================
  # ENVIRONMENT & SYSTEM PACKAGES
  # ============================================================================
  environment = {
    localBinInPath = true;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";                # Enable Wayland for Chromium-based apps
      MOZ_ENABLE_WAYLAND = "1";            # Enable Wayland for Firefox
    };
    
    systemPackages = 
      (with pkgs-stable; [
        # Stable packages go here
      ])
      ++
      (with pkgs; [
        # ========================================================================
        # CORE SYSTEM UTILITIES
        # ========================================================================
        inotify-tools          # File system event monitoring
        e2fsprogs              # ext2/3/4 filesystem utilities
        util-linux             # Essential system utilities (mount, fdisk, etc.)
        openssl                # Cryptography toolkit
        kbd                    # Keyboard utilities
        killall                # Process termination utility
        sudo                   # Privilege escalation
        
        # System information
        btop                  # Modern system monitor
        nvtopPackages.full    # GPU monitoring
        glxinfo               # OpenGL information
        usbutils              # USB utilities (lsusb)
        pciutils              # PCI utilities (lspci)
        
        # File system tools
        mlocate                # File location database
        nix-index              # Nix package search
        
        # ========================================================================
        # EDITORS & BASIC TOOLS
        # ========================================================================
        vim                    # Text editor
        nano                   # Simple text editor
        bc                     # Calculator
        tldr                   # Simplified man pages
        pay-respects           # Modern 'thefuck' command corrector
        imagemagick            # Image manipulation
        
        # ========================================================================
        # DEVELOPMENT TOOLS & LIBRARIES
        # ========================================================================
        # Version control & build tools
        git                    # Version control
        nodejs_20              # JavaScript runtime
        meson                  # Build system
        cmake                  # Build system generator
        ninja                  # Build system
        gnumake                # GNU Make
        pkg-config             # Library metadata tool
        gcc14                  # GNU Compiler Collection
        typescript             # TypeScript compiler
        node2nix               # NPM to Nix converter
        nil                    # Nix Language Server
        sublime4               # Text editor
        zulu23                 # OpenJDK distribution
        
        # Development libraries
        glib.dev               # Development files
        glibc.dev              # C library development files
        gobject-introspection.dev  # Object introspection
        pango.dev              # Text rendering
        harfbuzz.dev           # Text shaping
        cairo.dev              # 2D graphics
        gdk-pixbuf.dev         # Image loading
        atk.dev                # Accessibility toolkit
        
        # ========================================================================
        # HARDWARE & DEVICE SUPPORT
        # ========================================================================
        # USB & Mobile devices
        libftdi1               # FTDI USB device support
        gvfs                   # Virtual file system
        jmtpfs                 # MTP filesystem
        android-udev-rules     # Android USB rules
        libmtp                 # Media Transfer Protocol
        
        # Camera support
        libcamera              # Camera support library
        
        # ========================================================================
        # BOOT & SYSTEM MANAGEMENT
        # ========================================================================
        # EFI and boot management
        efibootmgr             # EFI boot manager
        binutils               # Binary utilities
        systemdUkify           # Unified Kernel Image creation
        
        # Virtualization & containers
        proot                  # User-space chroot
        nixos-generators       # NixOS image generators
        
        # ========================================================================
        # WAYLAND & DESKTOP ENVIRONMENT
        # ========================================================================
        # Core Wayland components
        xwayland               # X11 compatibility layer
        wayland-scanner        # Wayland protocol scanner
        waypipe                # Wayland network forwarding
        
        # Desktop portals
        xdg-desktop-portal-hyprland  # Hyprland desktop portal
        xdg-desktop-portal-gtk       # GTK desktop portal
        
        # Input & interaction
        brightnessctl          # Screen brightness control
        ydotool                # Input automation for Wayland
        wtype                  # Text input for Wayland
        wl-clipboard           # Clipboard utilities
        evtest                 # Input event testing
        wev                    # Wayland event viewer
        
        # Display & color
        wlsunset               # Blue light filter
        fcitx5                 # Input method framework
        
        # Application launcher
        wofi                   # Application launcher
        libqalculate           # Calculator library
        
        # ========================================================================
        # MULTIMEDIA & STREAMING
        # ========================================================================
        # Video recording & processing
        wf-recorder            # Wayland screen recorder
        ffmpeg-full            # Complete multimedia framework
        mkvtoolnix-cli         # Matroska video tools
        
        # Remote desktop & streaming
        sunshine               # Game streaming server
        moonlight-qt           # Game streaming client
        rustdesk-flutter       # Remote desktop client
        remmina                # Remote desktop client
        wayvnc                 # VNC server for Wayland
        freerdp3Override       # RDP client
        
        # Graphics & video acceleration
        vulkan-tools           # Vulkan utilities
        libva                  # Video acceleration framework
        libva-utils            # Video acceleration utilities
        
        # ========================================================================
        # GTK & GUI LIBRARIES
        # ========================================================================
        # GTK3 components
        gtk3.dev               # GTK3 development files
        libappindicator-gtk3.dev  # System tray support
        libnotify.dev          # Notification development files
        
        # GTK4 components
        gtk4.dev               # GTK4 development files
        
        # Additional GTK components
        gjs.dev                # GJS development files
        gtksourceview.dev      # Development files
        
        # Tk toolkit
        tk                     # Tcl/Tk GUI toolkit
        
        # ========================================================================
        # SYSTEM INTEGRATION & SESSION
        # ========================================================================
        # Authentication & session
        polkit                 # Privilege escalation framework
        polkit_gnome           # GNOME polkit agent
        kdePackages.polkit-kde-agent-1  # KDE polkit agent
        dconf                  # Configuration database
        gnome-keyring          # Credential storage
        linux-pam              # Pluggable Authentication Modules
        
        # Clipboard & utilities
        cliphist               # Clipboard history
        zenity                 # Dialog boxes
        
        # File management
        xfce.thunar            # File manager
        
        # X11 compatibility
        xorg.xinit             # X11 initialization
        xorg.xhost             # X11 access control
        
        # Commented out packages (consider if needed)
        # android-tools         # Android development tools
        # kdePackages.xwaylandvideobridge  # Video bridge for screen sharing
        # kdePackages.kde-cli-tools        # KDE command line tools
      ]);
  };
}
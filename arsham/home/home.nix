{
  pkgs,
  inputs,
  lib, 
  pkgs-stable, 
  user,
  ... 
}:

{
  imports = [
    ./hyprland
    ./mpv
    ./obs
    ./terminal
    ./theme
    ./udiskie
    ./vscode
  ];
  
  xdg.userDirs.enable = true;
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  services.polkit-gnome.enable = true;
  
  home = {
  
    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
    stateVersion = "25.11";
    
    sessionVariables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
      LIBVA_DRIVER_NAME = "iHD";
    };
    
    packages = 
      (with pkgs-stable; [
        # Your stable pkgs here
      ])
      ++
      (with pkgs; [
        # ============================================================================
        # CORE SYSTEM UTILITIES
        # ============================================================================
        fd                  # Modern find replacement
        procps              # Process utilities (ps, top, etc.)
        fastfetch           # System info display
        htop                # Interactive process viewer
        iotop               # I/O monitoring
        iftop               # Network bandwidth monitoring
        mission-center      # System monitoring GUI
        sysstat             # System performance tools
        lm_sensors          # Hardware sensors
        ethtool             # Ethernet tool
        pciutils            # PCI utilities (lspci)
        usbutils            # USB utilities (lsusb)
        
        # ============================================================================
        # FILE MANAGEMENT & ARCHIVES
        # ============================================================================
        nnn                 # Terminal file manager
        baobab              # Disk usage analyzer
        nautilus            # GNOME file manager
        file-roller         # Archive manager GUI
        
        # Archive formats
        zip
        unzip
        xz
        p7zip
        rar
        zstd
        peazip              # GUI archive manager
        
        # ============================================================================
        # CLI UTILITIES & TOOLS
        # ============================================================================
        ripgrep             # Fast grep alternative
        jq                  # JSON processor
        yq-go               # YAML processor
        eza                 # Modern ls replacement
        fzf                 # Fuzzy finder
        tree                # Directory tree display
        which               # Command location finder
        gnused              # Stream editor
        gnutar              # Archive utility
        gawk                # Text processing
        cowsay              # Fun text display
        glow                # Markdown renderer
        bc                  # Calculator
        
        # ============================================================================
        # NETWORKING & INTERNET
        # ============================================================================
        # Browsers
        inputs.zen-browser.packages.${pkgs.system}.default
        brave
        
        # Communication
        telegram-desktop
        vesktop             # Alternative Discord client
        thunderbird         # Email client
        
        # Network tools
        mtr                 # Network diagnostic
        iperf3              # Network performance
        dnsutils            # DNS utilities
        ldns                # DNS library tools
        aria2               # Download manager
        socat               # Network relay
        nmap                # Network scanner
        ipcalc              # IP calculator
        
        # VPN & Remote
        networkmanager-openvpn
        openvpn
        wireguard-tools
        anydesk             # Remote desktop
        tigervnc            # VNC client
        
        # ============================================================================
        # DEVELOPMENT TOOLS
        # ============================================================================
        # Development tools
        git                 # Version control
        nil                 # Nix LSP
        graphviz            # Graph visualization
        
        # Static site generation
        hugo
        nodejs_20
        
        # ============================================================================
        # EMBEDDED & HARDWARE DEVELOPMENT
        # ============================================================================
        # STM32 Development
        stm32cubemx
        stm32flash
        stlink-gui
        stlink-tool
        gcc-arm-embedded
        
        # General embedded
        platformio
        esptool
        dtc                 # Device tree compiler
        pkgs.pkgsCross.aarch64-multiplatform.stdenv.cc
        
        # Mobile/Android development
        edl                 # Qualcomm tools
        pmbootstrap         # PostmarketOS
        gptfdisk            # GPT partitioning
        apktool             # Android APK tool
        waydroid            # Android emulator
        
        # Arduino
        arduino-ide
        
        # ============================================================================
        # MULTIMEDIA & CREATIVE
        # ============================================================================
        # Image editing
        gimp
        darktable           # RAW photo processor
        pngquant            # PNG optimizer
        
        # 3D & Video
        blender
        wf-recorder         # Wayland screen recorder
        webcamoid           # Webcam utility
        
        # Audio/Music
        audacity
        ardour              # Professional audio
        tauon               # Music player
        pavucontrol         # PulseAudio control
        playerctl           # Media player control
        mpdris2             # MPD integration
        
        # Video players
        vlc
        mpvpaper            # Video wallpaper
        ani-cli             # Anime streaming
        
        # ============================================================================
        # SYSTEM THEMING & DESKTOP
        # ============================================================================
        # GNOME components
        gnome-keyring
        gnome-control-center
        gnome-bluetooth
        blueberry           # Bluetooth manager
        
        # Wallpapers & backgrounds
        waypaper
        swaybg
        swww
        
        # Hyprland/Wayland tools
        hyprpicker          # Color picker
        wl-clipboard        # Clipboard manager
        cliphist            # Clipboard history
        fuzzel              # Application launcher
        slurp               # Screen area selection
        grim                # Screenshot utility
        swappy              # Screenshot editor
        wofi-calc           # Calculator for wofi
        
        # System integration
        brightnessctl       # Brightness control
        wlsunset            # Blue light filter
        libnotify           # Notifications
        xdg-user-dirs       # User directories
        upower              # Power management
        yad                 # Dialog boxes
        ydotool             # Input automation
        
        # ============================================================================
        # SYSTEM LIBRARIES & DEPENDENCIES
        # ============================================================================
        bluez               # Bluetooth stack
        wireplumber         # Audio session manager
        networkmanager      # Network management
        
        # GTK/UI libraries
        libdbusmenu-gtk3
        webp-pixbuf-loader
        gtk-layer-shell
        gtksourceview3
        gobject-introspection
        gjs                 # GNOME JavaScript
        
        # Development libraries (Consider: Move to shell.nix for projects)
        tinyxml-2
        gtkmm3
        gtksourceviewmm
        cairomm
        
        # ============================================================================
        # FONTS
        # ============================================================================
        google-fonts
        ibm-plex
        
        # ============================================================================
        # GAMING & ENTERTAINMENT
        # ============================================================================
        prismlauncher       # Minecraft launcher
        
        # ============================================================================
        # PRODUCTIVITY & OFFICE
        # ============================================================================
        ghex                # Hex editor
        tesseract           # OCR
        clipgrab            # Video downloader
        
        # ============================================================================
        # UTILITIES & MISC
        # ============================================================================
        ventoy-full         # Bootable USB creator
        gparted             # Partition editor
        gnome.gvfs          # Virtual filesystem
        
        # System debugging
        strace              # System call tracer
        ltrace              # Library call tracer
        lsof                # List open files
        
        # Compression/decompression
        gnupg               # Encryption
        
        # Misc tools
        coreutils
        curl
        ddcutil             # Monitor control
        gojq                # Go JSON processor
        dart-sass           # Sass compiler
        axel                # Download accelerator
        
        # ============================================================================
        # PYTHON ENVIRONMENT
        # ============================================================================
        pyenv.out
        python312Packages.debugpy
        (python312.withPackages(ps: with ps; [
          # Core Python packages
          numpy
          pillow
          setuptools-scm
          wheel
          pip
          certifi
          colorama
          tqdm
          psutil
          importlib-metadata
          appdirs
          six
          hatchling
          ordered-set
          inotify-simple
          
          # Audio processing
          aubio
          pyaudio
          speechrecognition
          
          # GUI frameworks
          tkinter
          pycairo
          pygobject3
          
          # System integration
          pywayland
          dbus-python
          pydbus
          evdev
          xkeysnail
          watchdog
          
          # Theming
          materialyoucolor
          material-color-utilities
          pywal
          
          # Development
          poetry-core
          breezy
          
          # APIs
          google
        ]))
      ])
      ++
      (builtins.filter lib.isDerivation (builtins.attrValues pkgs-stable.nerd-fonts));
  };
}
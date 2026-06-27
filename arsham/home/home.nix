{
  pkgs,
  config,
  inputs,
  lib, 
  pkgs-stable, 
  user,
  frostix,
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
    ./scripts
  ];
  
  xdg.userDirs.enable = true;
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  services = {
    polkit-gnome.enable = true;
    wallpaper-manager = {
      enable = false;
      videoWallpaper = "${config.home.homeDirectory}/nixo/resources/wallpapers/mitsu.mp4";
      staticWallpaper = "${config.home.homeDirectory}/nixo/resources/wallpapers/mitsu.png";
      vmName = "Win10";
      useLibvirt = true;
      checkInterval = 5;
      displayOutput = "*";
      swwwTransition = "fade";
      transitionDuration = 1;
    };
  };
  
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
        # Add stable packages here if needed
      ])
      ++
      (with pkgs; [
        # Core system utilities
        fd
        procps
        fastfetch
        htop
        iotop
        iftop
        mission-center
        sysstat
        lm_sensors
        ethtool
        pciutils
        usbutils
        
        # File management & archives
        nnn
        baobab
        nautilus
        file-roller
        zip
        unzip
        xz
        p7zip
        rar
        zstd
        peazip
        
        # CLI utilities
        ripgrep
        jq
        yq-go
        eza
        fzf
        tree
        which
        gnused
        gnutar
        gawk
        cowsay
        glow
        bc
        
        # Browsers
        inputs.zen-browser.packages.${pkgs.system}.default
        brave
        firefox
        
        # Communication
        telegram-desktop
        vesktop
        thunderbird
        
        # Network tools
        mtr
        iperf3
        dnsutils
        ldns
        aria2
        socat
        nmap
        ipcalc
        networkmanager-openvpn
        openvpn
        wireguard-tools
        anydesk
        tigervnc
        
        # Development tools
        git
        git-lfs
        git-filter-repo
        nil
        graphviz
        lmstudio
        qucs-s
        hugo
        nodejs_20
        
        # STM32 development
        stm32cubemx
        stm32flash
        stlink-gui
        stlink-tool
        gcc-arm-embedded
        
        # Embedded & hardware
        platformio
        esptool
        dtc
        pkgs.pkgsCross.aarch64-multiplatform.stdenv.cc
        pkgsCross.aarch64-multiplatform.binutils
        pkgsCross.aarch64-multiplatform.buildPackages.gcc
        pkgsCross.aarch64-multiplatform.buildPackages.binutils
        bison
        flex
        arduino-ide
        
        # Mobile/Android development
        frostix.mtkclient-git
        edl
        pmbootstrap
        gptfdisk
        apktool
        waydroid
        android-tools
      #  android-studio
        imgpatchtools
        scrcpy
        
        # Image editing
        gimp
        darktable
        pngquant
        
        # 3D & video
        blender
        wf-recorder
        webcamoid
        
        # Audio/music
        audacity
      #  (ardour.override { videoSupport = false; })
        ardour
        tauon
        pavucontrol
        playerctl
        mpdris2
        
        # Video players
        vlc
        mpvpaper
        ani-cli
        
        # GNOME components
        gnome-keyring
        gnome-control-center
        gnome-bluetooth

        # Wallpapers & backgrounds
        waypaper
        swaybg
        awww
        
        # Hyprland/Wayland tools
        hyprpicker
        wl-clipboard
        cliphist
        fuzzel
        slurp
        grim
        swappy
        wofi-calc
        
        # System integration
        brightnessctl
        wlsunset
        libnotify
        xdg-user-dirs
        upower
        yad
        ydotool
        
        # System libraries
        bluez
        wireplumber
        networkmanager
        libdbusmenu-gtk3
        webp-pixbuf-loader
        gtk-layer-shell
        gtksourceview3
        gobject-introspection
        gjs
        
        # Development libraries (Consider: Move to per-project shell.nix)
        tinyxml-2
        gtkmm3
        gtksourceviewmm
        cairomm
        
        # Fonts
        google-fonts
        ibm-plex
        
        # Gaming
        prismlauncher
        
        # Productivity
        ghex
        tesseract
        super-productivity
        
        # Utilities
        ventoy-full
        gparted
        gnome.gvfs
        strace
        ltrace
        lsof
        gnupg
        coreutils
        curl
        ddcutil
        gojq
        dart-sass
        axel
        google-authenticator
        
        # Python environment
        pyenv.out
        python312Packages.debugpy
        (python313.withPackages(ps: with ps; [
          # Core
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
          
          # Audio
        #  aubio-ledfx
          pyaudio
          speechrecognition
          
          # GUI
          tkinter
          pycairo
          pygobject3
          
          # System
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
          ipykernel
          jupyter
          notebook
          open-interpreter
          
          # APIs
          google
        ]))
      ])
      ++
      (builtins.filter lib.isDerivation (builtins.attrValues pkgs-stable.nerd-fonts));
  };
}

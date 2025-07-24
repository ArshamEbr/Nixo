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
        # Utilities and tools
        warp-plus
        fd
        bluez
        procps
        v2rayn
        python312Packages.debugpy
        looking-glass-client
        wireguard-tools
        
        # Media and creative
        thunderbird
        blender
        tigervnc
        webcamoid
        pngquant
        lowfi
        ani-cli
        tauon
        
        # Fonts
        google-fonts
        ibm-plex
        
        # Embedded development
        stm32cubemx
        stm32flash
        stlink-gui
        stlink-tool
        platformio
        esptool
        gcc-arm-embedded
        dtc
        pkgs.pkgsCross.aarch64-multiplatform.stdenv.cc
        edl
        pmbootstrap
        gptfdisk
        
        # Music and file management
        mpdris2
        ghex
        baobab
        
        # Archiving
        peazip
        
        # Android tools
        apktool
        waydroid
        
        # Gaming
        prismlauncher
        
        # Arduino
        arduino-ide
        
        # Bootable media
        ventoy-full
        
        # Networking
        networkmanager-openvpn
        openvpn
        openvpn3
        anydesk
        
        # System info
        fastfetch
        nnn
        
        # Archives
        zip
        xz
        unzip
        p7zip
        
        # CLI utilities
        ripgrep
        jq
        yq-go
        eza
        fzf
        
        # Browsers and communication
        inputs.zen-browser.packages.${pkgs.system}.default
        firefox
        brave
        telegram-desktop
        discord
        vesktop
        
        # Creative tools
        darktable
        gimp
        htop
        nil
        
        # Networking tools
        mtr
        iperf3
        dnsutils
        ldns
        aria2
        socat
        nmap
        ipcalc
        
        # Misc utilities
        cowsay
        file
        which
        tree
        gnused
        gnutar
        gawk
        zstd
        gnupg
        rar
        wofi-calc
        
        # Productivity
        hugo
        glow
        
        # Monitoring
        iotop
        iftop
        
        # System call monitoring
        strace
        ltrace
        lsof
        
        # System tools
        sysstat
        lm_sensors
        ethtool
        pciutils
        usbutils
        mission-center
        clipgrab
        ardour
        audacity
        gparted
        gnome.gvfs
        
        # Development
        git
        
        # MicroTex dependencies
        tinyxml-2
        gtkmm3
        gtksourceviewmm
        cairomm
        
        # Version control
        graphviz
        cvs
        mercurial
        p4
        subversion
        
        # Python
        pyenv.out
        (python312.withPackages(ps: with ps; [
          aubio
          numpy
          materialyoucolor
          material-color-utilities
          pillow
          poetry-core
          pywal
          setuptools-scm
          wheel
          pywayland
          psutil
          importlib-metadata
          certifi
          colorama
          breezy
          tqdm
          pydbus
          dbus-python
          pygobject3
          watchdog
          pip
          evdev
          appdirs
          inotify-simple
          ordered-set
          six
          hatchling
          pycairo
          xkeysnail
          speechrecognition
          pyaudio
          tkinter
          google
        ]))
        
        # Player and audio
        pavucontrol
        wireplumber
        libdbusmenu-gtk3
        playerctl
        mpvpaper
        vlc
        waypaper
        swaybg
        swww
        
        # GTK
        webp-pixbuf-loader
        gtk-layer-shell
        gtksourceview3
        upower
        yad
        ydotool
        # Removed wrapGAppsHook (build tool)
        gobject-introspection
        
        # GNOME
      #  polkit-gnome
        gnome-keyring
        gnome-control-center
        gnome-bluetooth
        file-roller
        
        # GNOME desktop
        nautilus
        nodejs_20
        yaru-theme
        blueberry
        networkmanager
        brightnessctl
        wlsunset
        gjs
        # AGS and Hyprland dependencies
        coreutils
        cliphist
        curl
        ddcutil
        fuzzel
        gojq
        dart-sass
        axel
        wl-clipboard
        hyprpicker
        libnotify
        bc
        xdg-user-dirs
        
        # Themes
        gradience
        catppuccin-gtk
        
        # Screenshot and recorder
        swappy
        wf-recorder
        grim
        tesseract
        slurp
      ])
      ++
      (builtins.filter lib.isDerivation (builtins.attrValues pkgs-stable.nerd-fonts));
  };
}
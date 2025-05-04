{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }: 
let
  wofi-calc = pkgs.fetchFromGitHub {
    owner = "Zeioth";
    repo = "wofi-calc";
    rev = "edd316f3f40a6fcb2afadf5b6d9b14cc75a901e0";
    sha256 = "sha256-y8GoTHm0zPkeXhYS/enNAIrU+RhrUMnQ41MdHWWTPas=";
  };
  winapps = pkgs.fetchFromGitHub {
    owner = "celesrenata";
    repo = "winapps";
    rev = "0319c70fa0dec2da241e9a4b4e35a164f99d6307";
    sha256 = "sha256-+ZAtEDrHuLJBzF+R6guD7jYltoQcs88qEMvvpjiAXqI=";
  };
  in
  {

    services.xserver.xkb.options = "ctrl:nocaps";

    # Packages that should be installed to the user profile.
    users.users.${user.name}.packages = 

    (with pkgs-old; [
      gnome.gvfs
    ])

    ++

    (with pkgs; [
      thunderbird

      blender
      # VNC
      tigervnc
      # Camera
      webcamoid

      # Fonts
      nerdfonts
      
      stm32cubemx
      ncmpcpp
      mpdris2
      ghex
      baobab
      
      peazip
      kdePackages.ark

      apktool
      # Android EMU
      waydroid
      
      # Minecraft
      prismlauncher

      # Arduino
      arduino-ide
      
      # Ventoy
      ventoy-full

      networkmanager-openvpn
      openvpn
      openvpn3

      fastfetch
      nnn
  
      # archives
      zip
      xz
      unzip
      p7zip
  
      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
  
      # programs
      inputs.zen-browser.packages.${pkgs.system}.default
      firefox
      brave
      telegram-desktop
      discord #TODO: blocked in iran ig
      vesktop
      darktable
      gimp
      htop
      nil
      looking-glass-client
    #  krita
      anydesk
  
      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils  # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc  # it is a calculator for the IPv4/v6 addresses
      nmap
      
      # misc
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
  
      # productivity
      hugo
      glow
  
      iotop
      iftop
  
      # system call monitoring
      strace
      ltrace
      lsof
  
      # system tools
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils
      wofi-calc
      mission-center
      parabolic
      clipgrab
      ardour
      audacity
      gparted
  
      # Development
      git
  
      # MicroTex Deps
      tinyxml-2
      gtkmm3
      gtksourceviewmm
      cairomm
  
      # Other
      graphviz
      cvs
      mercurial
      p4
      subversion
  
      # Python
      pyenv.out
      (python312.withPackages(ps: with ps; [
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
        # debugpy.overrideAttrs (final: prev: {
        #   pytestCheckPhase = ''true'';
        # })
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
  
      # Player and Audio
      pavucontrol
      wireplumber
      libdbusmenu-gtk3
      playerctl
      mpvpaper
      vlc
      waypaper
      swaybg
      swww
      yt-dlp

      # GTK
      webp-pixbuf-loader
      gtk-layer-shell
      gtksourceview3
      upower
      yad
      ydotool
      gobject-introspection
      wrapGAppsHook
      
      # Gnome Stuff
      polkit_gnome
      gnome-keyring
      gnome-control-center
      gnome-bluetooth
      file-roller

      # Gnome-shell
      nautilus
      nodejs_20
      yaru-theme
      blueberry
      networkmanager
      brightnessctl
      wlsunset
      gjs
      gjs.dev
  
      # AGS and Hyprland dependencies.
      coreutils
      cliphist
      curl
      ddcutil
      fuzzel
      ripgrep
      gojq
      dart-sass
      axel
      wl-clipboard
      hyprpicker
    #  gammastep
      libnotify
      bc
      xdg-user-dirs
  
      # Themes
      
      gradience
      catppuccin-gtk
  
      # Screenshot and Recorder
      swappy
      wf-recorder
      grim
      tesseract
      slurp 
    ])
  
    ++
  
    (with pkgs-unstable; [
      v2rayn
      python312Packages.debugpy
    ]);
  }
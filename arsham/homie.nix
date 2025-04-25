{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }: 
let
  wofi-calc = pkgs.fetchFromGitHub {
    owner = "Zeioth";
    repo = "wofi-calc";
    rev = "edd316f3f40a6fcb2afadf5b6d9b14cc75a901e0";
    sha256 = "sha256-y8GoTHm0zPkeXhYS/enNAIrU+RhrUMnQ41MdHWWTPas=";
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
      firefox
      thunderbird
      # hmmm
      #wayfirePlugins.wcm

      blender
      # VNC
      tigervnc
      # Camera
      webcamoid

      # Fonts
      nerdfonts
      
    #  stm32cubemx
      ncmpcpp
      mpdris2
      ghex
      baobab
      
      peazip
      kdePackages.ark
      #
      apktool
      # Androind EMU
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

      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them
      fastfetch
      nnn # terminal file manager
  
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
  
      # Games
      antimicrox
  
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
      mpv
      vlc
      waypaper
      swaybg
      swww
      yt-dlp
  
      # GTK
      webp-pixbuf-loader
      gtk-layer-shell
      gtk3
      gtksourceview3
      upower
      yad
      ydotool
      gobject-introspection
      wrapGAppsHook
  
      # QT
      libsForQt5.qwt
  
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
      libsForQt5.qtutilities
      coreutils
      cliphist
      curl
      ddcutil
      fuzzel
      ripgrep
      gojq
      dart-sass
      axel
      wlogout
      wl-clipboard
      hyprpicker
    #  gammastep
      libnotify
      bc
      xdg-user-dirs
  
      # Shells and Terminals
      starship
  
      # Themes
      libsForQt5.qt5ct
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
{ inputs, pkgs, pkgs-old, pkgs-unstable, ... }: 
let
  celes-dots = pkgs.fetchFromGitHub {
    owner = "celesrenata";
    repo = "dotfiles";
    rev = "a24961dd618ca10cfa50851aedff2a7e1affdeb0";
    sha256 = "sha256-QQVeINXRjRmU9eOX1OUTzHu0amz4ZFCJK8n8jYo+YPM=";
  };
  arsham-nixo = pkgs.fetchFromGitHub {
    owner = "ArshamEbr";
    repo = "Nixo";
    rev = "86cdd2150b65be7bc050dc5ab99412e1ae3a6533";
    sha256 = "1j2flfl3jfh3igm94qdfqyaw7l49awxa2nbxwsw7qdbrsmx1n8q8";
  };
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
  imports = [ 
    inputs.ags.homeManagerModules.default 
    ./hyprland
   ];

  services = {
 
    udiskie = {
      enable = true;
      notify = true;
      tray = "auto";
    };

    amberol = { # Cool-ish music player
      enable = true;
      enableRecoloring = true;
    };
 
  };

  gtk = { # Theme stuff
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme.overrideAttrs {
        src = inputs.morewaita;
      };
    };
  };

  programs = {

    home-manager.enable = true;

    ags = {
      enable = true;
      configDir = null;
      extraPackages = with pkgs; [
        gtksourceview
        gnome.gvfs
        webkitgtk
        accountsservice
      ];
    };
    
    # Modular Programs

    vscode = { # VSCode
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        #dracula-theme.theme-dracula
        #vscodevim.vim
        #yzhang.markdown-all-in-one
        ms-python.python
        oderwat.indent-rainbow
        eamodio.gitlens
        jnoortheen.nix-ide
        danielsanmedium.dscodegpt
      ];
    };

    btop = {
      enable = true;
      settings = {
        #package = pkgs-unstable.btop;
        color_theme = "Default";
        theme_background = false;
        update_ms = 100;
        rounded_corners = true;
      };
    };

    obs-studio = { # OBS
      enable = true;
      package = pkgs-unstable.obs-studio;
      plugins = with pkgs-unstable.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    };

    starship = { # starship - an customizable prompt for any shell
      enable = true;
      settings = { # custom settings
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

  #  alacritty = { # alacritty - a cross-platform, GPU-accelerated terminal emulator
  #    enable = true;
  #    settings = { # custom settings
  #      scrolling.history = 10000;
  #      terminal.shell.program = "fish";
  #      scrolling.multiplier = 5;
  #      selection.save_to_clipboard = true;
  #      env.TERM = "xterm-256color";
  #      colors = {
  #        primary = {
  #          background = "#0F131C";
  #          foreground = "#DFE2EF";
  #        };
  #        normal = {
  #          black = "#0F131C";
  #          red = "#FFB4AB";
  #          green = "#005CBA";
  #          yellow = "#D7E3FF";
  #          blue = "#D7E3FF";
  #          magenta = "#E0E2FF";
  #          cyan = "#AAC7FF";
  #          white = "#C1C6D6";
  #        };
  #        bright = {
  #          black = "#0F131C";
  #          red = "#FFB4AB";
  #          green = "#005CBA";
  #          yellow = "#D7E3FF";
  #          blue = "#D7E3FF";
  #          magenta = "#E0E2FF";
  #          cyan = "#AAC7FF";
  #          white = "#C1C6D6";
  #        };
  #      };
  #      cursor = {
  #        style = "Beam";
  #        thickness = 1;
  #      };
  #      window = {
  #        opacity = 0.2; # Adjust transparency (0.0 - fully transparent, 1.0 - opaque)
  #        padding = { x = 10; y = 10; }; # Adds padding around the terminal
  #        dynamic_padding = true;
  #      };
  #      font = {
  #        normal = {
  #          family = "SpaceMono Nerd Font";
  #          style = "Regular";
  #        };
  #        size = 11;
  #      };
  #    };
  #  };

    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:"
      ''; # TODO add your custom bashrc here
      shellAliases = { # set some aliases, feel free to add more or remove some
        k = "kubectl";
        urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
        urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      };
      sessionVariables = {
        EDITOR = "nano";
      };
    };

  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`

  home = {

    username = "arsham";             # TODO please change the username to your own
    homeDirectory = "/home/arsham";  # TODO please change the home directory to your own
    stateVersion = "24.11";  

    sessionVariables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    };

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    file = {

      ".configstaging" = {
        source = pkgs.end-4-dots;
        recursive = true;   # link recursively
        executable = true;  # make all files executable
      };

      "Wallpapers" = {
        source = arsham-nixo + "/resources/wallpapers";
        recursive = true;
      };

      "winapps/pkg" = {
        source = winapps;
        recursive = true;
        executable = true;
      };

      "winapps/runmefirst.sh" = {
        source = winapps + "/runmefirst.sh";
      };
    
      ".local/bin/initialSetup.sh" = {
        source = pkgs.end-4-dots + "/.local/bin/initialSetup.sh";
      };
  
      ".local/bin/agsAction.sh" = {
        source = celes-dots + "/.local/bin/agsAction.sh";
      };
  
      ".local/bin/regexEscape.sh" = {
        source = celes-dots + "/.local/bin/regexEscape.sh";
      };
  
      ".local/bin/wofi-calc" = {
        source = wofi-calc + "/wofi-calc.sh";
      };
    
      ".local/bin/sunshine" = {
        source = celes-dots + "/.local/bin/sunshineFixed";
      };

    };
    
    # Packages that should be installed to the user profile.
    packages = 
      (with pkgs-old; [
      gnome.gvfs
    ])

    ++

    (with pkgs; [

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
  
      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      # nix-output-monitor # not needed when using nh
  
      # productivity
      hugo # static site generator
      glow # markdown previewer in terminal
  
      iotop # io monitoring
      iftop # network monitoring
  
      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files
  
      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
      wofi-calc
      mission-center
  
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
      gnome-shell
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
      gammastep
      libnotify
      bc
      xdg-user-dirs
  
      # Shells and Terminals
      starship
      foot
  
      # Themes
      adw-gtk3
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

  };

  xresources.properties = { # set cursor size and dpi for 4k monitor
    "Xcursor.size" = 24;
    "Xft.dpi" = 172;
  };
}

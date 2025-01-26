{ inputs, pkgs, pkgs-old, pkgs-unstable, ... }: 
let
  celes-dots = pkgs.fetchFromGitHub {
    owner = "celesrenata";
    repo = "dotfiles";
    rev = "a24961dd618ca10cfa50851aedff2a7e1affdeb0";
    sha256 = "sha256-QQVeINXRjRmU9eOX1OUTzHu0amz4ZFCJK8n8jYo+YPM=";
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

  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with pkgs; [
      gtksourceview
      gnome.gvfs
      webkitgtk
      accountsservice
    ];
  };

  # TODO please change the username & home directory to your own
  home.username = "arsham";
  home.homeDirectory = "/home/arsham";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`

  home.file.".configstaging" = {
    source = pkgs.end-4-dots;
    recursive = true;   # link recursively
    executable = true;  # make all files executable
  };
  home.file."Backgrounds" = {
    source = celes-dots + "/Backgrounds";
    recursive = true;
  };

  home.file."winapps/pkg" = {
    source = winapps;
    recursive = true;
    executable = true;
  };
  home.file."winapps/runmefirst.sh" = {
    source = winapps + "/runmefirst.sh";
  };

  home.file.".local/bin/initialSetup.sh" = {
    source = pkgs.end-4-dots + "/.local/bin/initialSetup.sh";
  };
  home.file.".local/bin/agsAction.sh" = {
    source = celes-dots + "/.local/bin/agsAction.sh";
  };
  home.file.".local/bin/regexEscape.sh" = {
    source = celes-dots + "/.local/bin/regexEscape.sh";
  };
  home.file.".local/bin/wofi-calc" = {
    source = wofi-calc + "/wofi-calc.sh";
  };
  #home.file.".config/hypr/hyprland.conf" = {
  #  source = pkgs.end-4-dots + "/hypr/hyprland.conf.bak";
  #};
  home.file.".local/bin/sunshine" = {
    source = celes-dots + "/.local/bin/sunshineFixed";
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 172;
  };
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # Modular Programs
  # VSCode
  programs.vscode = {
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
  programs.btop = {
  enable = true;
  settings = {
    #package = pkgs-unstable.btop;
    color_theme = "Default";
    theme_background = false;
    update_ms = 100;
    rounded_corners = true;
  };
  };

  # Obs.
  programs.obs-studio = {
    enable = true;
    package = pkgs-unstable.obs-studio;
    plugins = with pkgs-unstable.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };

  # Packages that should be installed to the user profile.
  home.packages = 
  (with pkgs-old; [
    gnome.gvfs 
  ])

  ++

  (with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    pkgs-unstable.v2rayn
    networkmanager-openvpn
    openvpn
    openvpn3

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
    firefox
    chromium
    brave
    telegram-desktop
    discord #TODO: blocked
    vesktop
    darktable
    gimp
    htop
    nil
    udiskie
    looking-glass-client

    # Extra Launchers.

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

    # Games.
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
    virtiofsd /*
     Doing the Steps below is mandatory for sharing the dir with windows vm after installing the virtiofsd in linux :
     use the "which virtiofsd" command inside terminal and copy the output in 
     here : "<binary path="OUTPUT_HERE"/>"
     Then add the Filesystem in virt-manager from add hardware section and 
     copy the text above in xml section of that for example:
     #################################################################################
     <filesystem type="mount" accessmode="passthrough">
       <driver type="virtiofs"/>
       <binary path="/etc/profiles/per-user/arsham/bin/virtiofsd"/> #THIS RIGHT HERE!
       <source dir="/home/arsham/"/>
       <target dir="Home"/>
       <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
     </filesystem>
     ##############################################################################
     Download and install latest WinFSP inside your windows vm
     also dont forget to set the VirtIO-FS Service to start automaticly inside services
    */

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

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
    plasma-browser-integration
    playerctl
    swww
    mpvpaper
    mpv
    vlc
    waypaper

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
    #hyprland-qtutils
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

    # Screenshot and Recorder
    swappy
    wf-recorder
    grim
    tesseract
    slurp 
  ])

  ++

  (with pkgs-unstable; [
   # hypridle
   # hyprlock
    python312Packages.debugpy
  ]);

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
    sessionVariables = {
      EDITOR = "nano";
    };
  };
  
  home.sessionVariables = {
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }: 
let
  in
  {
  imports = [
    ./gtk
    ./hyprland
    ./mpv
    ./obs
    ./terminal
    ./udiskie
    ./vscode
  ];

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home = {

    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
    stateVersion = "25.05";  

    sessionVariables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
      LIBVA_DRIVER_NAME = "iHD";
    };

    packages =
    
      # Legacy/older packages
      (with pkgs-old; [
        gnome.gvfs
      ])
    
      ++
    
      # Main package list
      (with pkgs; [
    
        # Fonts (uncomment what you use)
        # ttf-material-symbols-variable-git 
        # ttf-jetbrains-mono-nerd 
        # ttf-ibm-plex 
        # app2unit-git 
        # psiphon3
    
        warp-plus
        fd
        bluez
        adwaita-icon-theme
        hicolor-icon-theme
        gnome-themes-extra
        gnome-icon-theme
        procps
    
        # Custom packages from inputs
        inputs.quickshell.packages.${pkgs.system}.default
    
        # Audio + UI
        cava
        thunderbird
        blender
    
        # VNC
        tigervnc
    
        # Camera
        webcamoid
    
        # Fonts
        # nerdfonts
        google-fonts
        ibm-plex
    
        # STM32/ESP dev tools
        stm32cubemx
        stm32flash
        stlink-gui
        stlink-tool
        stlink
        platformio
        esptool
    
        # Audio + Music
        ncmpcpp
        mpdris2
    
        # System GUI tools
        ghex
        baobab
        peazip
        kdePackages.ark
    
        # Reverse engineering / android
        apktool
        waydroid
    
        # Misc apps
        prismlauncher
        arduino-ide
        ventoy-full
        fastfetch
        nnn
    
        # Archive tools
        zip
        xz
        unzip
        p7zip
    
        # CLI utils
        ripgrep
        jq
        yq-go
        eza
        fzf
    
        # Browsers
        inputs.zen-browser.packages.${pkgs.system}.default
        firefox
        brave
    
        # Communication
        telegram-desktop
        discord
        vesktop
    
        # Creative
        darktable
        gimp
        htop
        nil
        anydesk
    
        # Networking tools
        mtr
        iperf3
        dnsutils
        ldns
        aria2
        socat
        nmap
        ipcalc
    
        # Misc CLI
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
    
        # Productivity
        hugo
        glow
    
        # Monitoring
        iotop
        iftop
    
        # Syscall + introspection
        strace
        ltrace
        lsof
    
        # System tools
        sysstat
        lm_sensors
        ethtool
        pciutils
        usbutils
    
        # Custom scripts & tools
        wofi-calc
        mission-center
        parabolic
        clipgrab
        ardour
        audacity
        gparted
    
        # Dev essentials
        git
    
        # MicroTex deps
        tinyxml-2
        gtkmm3
        gtksourceviewmm
        cairomm
    
        # VCS
        graphviz
        cvs
        mercurial
        p4
        subversion
    
        # Audio / sound
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
    
        # GTK + Gnome Integration
        webp-pixbuf-loader
        gtk-layer-shell
        gtksourceview3
        upower
        yad
        ydotool
        gobject-introspection
        wrapGAppsHook
    
        polkit_gnome
        gnome-keyring
        gnome-control-center
        gnome-bluetooth
        file-roller
    
        nautilus
        nodejs_20
        yaru-theme
        blueberry
        networkmanager
        brightnessctl
        wlsunset
        gjs
        gjs.dev
    
        # Hyprland/AGS deps
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
        libnotify
        bc
        xdg-user-dirs
    
        # GTK themes
        gradience
        catppuccin-gtk
    
        # Screenshot & screen recorder
        swappy
        wf-recorder
        grim
        tesseract
        slurp
      ])
    
      ++
    
      # Unstable packages
      (with pkgs-unstable; [
        v2rayn
        python312Packages.debugpy
        looking-glass-client
      ])
    
      ++
    
      # Nerd Fonts - filtered only valid derivations
      (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));

    file = {

    };

  };
}
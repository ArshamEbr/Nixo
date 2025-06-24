{ inputs, pkgs, lib, pkgs-old, pkgs-unstable, user, ... }:
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
        (with pkgs-old; [
          gnome.gvfs
        ])
        ++
        (with pkgs; [
          # Utilities and tools
          warp-plus
          fd
          bluez
          adwaita-icon-theme
          hicolor-icon-theme
          gnome-themes-extra
          gnome-icon-theme
          procps
  
          # Quickshell
          inputs.quickshell.packages.${pkgs.system}.default
  
          # Media and creative
          cava
          thunderbird
          blender
          tigervnc
          webcamoid
  
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
  
          # Music and file management
          ncmpcpp
          mpdris2
          ghex
          baobab
  
          # Archiving
          peazip
          kdePackages.ark
  
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
          wofi-calc
          mission-center
        #  parabolic
          clipgrab
          ardour
          audacity
          gparted
  
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
        #  yt-dlp
  
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
        (with pkgs-unstable; [
          v2rayn
          python312Packages.debugpy
          looking-glass-client
        ])
        ++
        (builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts));
    };
  }
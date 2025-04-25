{ inputs, pkgs, pkgs-old, pkgs-unstable, user, ... }: 
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

    mpd = {
      enable = true;
      musicDirectory = "~/Music";
      extraConfig = ''
        audio_output {
            type            "pulse"
            name            "MPD PulseAudio"
        }
  
        mixer_type "software"
        bind_to_address "localhost"
      '';
    };

    mpd-mpris.enable = true;

    mako = {
      enable = false;
      backgroundColor = "#1e1e2e"; # Dark background with a hint of elegance
      textColor = "#cdd6f4"; # Soft light text for readability
      borderColor = "#89b4fa"; # Cool blue border for a clean look
      borderSize = 2;
      borderRadius = 17; # Slightly larger radius for rounded edges
      font = "JetBrainsMono Nerd Font 12"; # Stylish and readable font
      padding = "15"; # Slightly larger padding for more space around the text
      margin = "30";
      anchor = "top-right";
      width = 390;
      height = 100;
      maxIconSize = 50;
      defaultTimeout = 7000;
      ignoreTimeout = false;
      layer = "overlay";
      icons = true;
      markup = true;
      extraConfig = ''
        [urgency=low]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
    
        [category=volume]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
    
        [category=brightness]
        default-timeout=1000
        background-color=#1e1e2e
        border-color=#89b4fa
      '';
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

    waybar = {
        enable = false;
        package = pkgs.waybar;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 0;
            spacing = 0;
            
            modules-left = [ "custom/launcher" "hyprland/workspaces" "custom/mpd" ];
            modules-center = [ "temperature" "cpu" "clock" "memory" "disk" ];
            modules-right = [ "tray" "network" "custom/network" "pulseaudio" "backlight" "custom/power" "battery" ];
            
            "hyprland/workspaces" = {
              format = "{name}";
              active-only = false;
              on-click = "activate";
            };
    
            temperature = {
              tooltip = false;
              interval = 3;
              format = " {temperatureC}°C";
              critical-threshold = 80;
              format-critical = " {temperatureC}°C";
              hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
              on-click = "foot -e btop";
            };
            
            "custom/launcher" = {
              format = " ";
              on-click = "rofi -show drun";
              tooltip = false;
            };
    
            clock = {
              format = "{:%H:%M}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };
    
            cpu = {
              format = " {usage}%";
              interval = 3;
            };
    
            memory = {
              format = "  {}%";
              interval = 3;
            };
    
            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon} {capacity}%";
              format-charging = "󰂄 {capacity}%";
              format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            };
    
            network = {
              format-wifi = "{essid} {signalStrength}%";
              format-ethernet = "󰈀 Connected";
              format-disconnected = "󰖪 Disconnected";
              tooltip-format = "{ifname} via {gwaddr}";
              on-click = "kitty -e nmtui";
            };
  
            "custom/network" = {
              "exec" = "way_network";
              "interval" = 1;
              "return-type" = "text";
            };
      
            pulseaudio = {
              format = "{icon}  {volume}%";
              format-muted = "  Muted";
              format-icons = {
                default = [ "" "" "" ];
              };
              on-click = "pavucontrol";
            };
    
            tray = {
              spacing = 12;
            };
  
            disk = {
              path = "/";
              format = " {percentage_used}%";
            };
  
            backlight = {
              device = "intel_backlight";
              format = "{icon} {percent}%";
              format-icons = ["🌑" "🌘" "🌗" "🌖" "🌕"];
            };
  
            "custom/mpd" = {
              format = "󰝚 {}";
              exec = ''
                sanitize_output() {
                  decoded=$(printf '%b' "''${1//%/\\x}" 2>/dev/null || echo "$1")
                  echo "$decoded" | 
                    iconv -cf utf-8 -t utf-8//TRANSLIT 2>/dev/null |
                    tr -cd '\11\12\15\40-\176' |  # Keep basic printable ASCII
                    sed -e 's/\\u[0-9a-fA-F]\{1,4\}//g' \
                        -e 's/[[:cntrl:]]//g' \
                        -e 's/^[[:space:]]*//' \
                        -e 's/[[:space:]]*$//'
                }
                players=$(playerctl -l 2>/dev/null)
                meta=""
                for player in $players; do
                  current=$(playerctl -p "$player" metadata --format '{{artist}} - {{title}}' 2>/dev/null)
                  [ -z "$current" ] || [ "$current" = " - " ] && 
                    current=$(playerctl -p "$player" metadata --format '{{title}}' 2>/dev/null)
                  if [ -z "$current" ]; then
                    url=$(playerctl -p "$player" metadata xesam:url 2>/dev/null)
                    if [ -n "$url" ]; then
                      filename=$(basename "''${url%%\?*}")
                      current=$(sanitize_output "$filename")
                      current="''${current%.*}"
                    fi
                  fi
                  [ -z "$meta" ] && [ -n "$current" ] && meta="$current"
                done
                if [ -z "$meta" ]; then
                  if [ -n "$players" ]; then
                    meta="Media player paused"
                  else
                    meta="No media player"
                  fi
                fi
                echo -n "$meta" | head -c 70 | tr -d '\n\r\0'
              '';
              return-type = "string";
              interval = 3;
              on-click = "playerctl play-pause";
            };
   
            "custom/power" = {
              exec = '' echo "󰓅" '';
              on-click = "tlp_mode";
              return-type = "text";
              interval = "once";
              format = "{}";
              tooltip = false;
            };
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 8px;
            font-family: "JetBrainsMono Nerd Font";
            font-size: 14px;
            min-height: 0;
          }
          
          window#waybar {
            background: rgba(40, 40, 40, 0.602);
            color: #cdd6f4;
            border-radius: 0px;
            margin: 0px 0px 0 0px;
          }
          
          #custom-mpd {
            color:rgba(145, 229, 255, 0.961);
            font-weight: bold;
            padding: 0 10px;
          }
          
          #workspaces button,
          #clock, 
          #battery, 
          #cpu, 
          #memory, 
          #network, 
          #pulseaudio,
          #custom-launcher,
          #temperature,
          #mpd,
          #backlight,
          #disk,
          #gamemode,
          #custom-power,
          #custom-mpd,
          #custom-network,
          #tray {
            background: transparent;
            margin: 0px 3px;
            padding: 0 6px;
          }
          
          /* Active workspace */
          #workspaces button.active {
            background: rgba(117, 147, 196, 0.602);
            color:rgb(151, 188, 249);
          }
          
          /* Hover effects */
          #workspaces button:hover,
          #clock:hover,
          #battery:hover,
          #cpu:hover,
          #memory:hover,
          #network:hover,
          #pulseaudio:hover,
          #custom-launcher:hover,
          #temperature:hover,
          #mpd:hover,
          #backlight:hover,
          #disk:hover,
          #gamemode:hover,
          #custom-power:hover,
          #custom-mpd:hover,
          #custom-network:hover,
          #tray:hover {
            background: rgba(49, 50, 68, 0.602); /* Darker on hover */
          }
          
          #temperature {
            color:rgb(0, 234, 255);
          }
          
          #temperature.critical {
            color:rgb(255, 19, 19);
            animation: blink 1s infinite;
          }
          
          @keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
          }
      '';
    };
    
    rofi = {
      enable = false;
      theme = "solarized";
      extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        font = "SpaceMono Nerd Font 11";
      };
    };

    ags = {
      enable = false;
      configDir = null;
      extraPackages = with pkgs; [
        gtksourceview
        gnome.gvfs
        webkitgtk
        accountsservice
      ];
    };

    vscode = { # VSCode
      enable = false;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        oderwat.indent-rainbow
        eamodio.gitlens
        jnoortheen.nix-ide
        danielsanmedium.dscodegpt
      ];
    };

    btop = {
      enable = false;
      settings = {
        color_theme = "Default";
        theme_background = false;
        update_ms = 100;
        rounded_corners = true;
      };
    };

    obs-studio = { # OBS
      enable = false;
      package = pkgs-unstable.obs-studio;
      plugins = with pkgs-unstable.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    };

    starship = { # starship - an customizable prompt for any shell
      enable = false;
      settings = { # custom settings
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:"
      ''; # TODO add your custom bashrc here
      shellAliases = { # set some aliases, feel free to add more or remove some
      };
      sessionVariables = {
        EDITOR = "nano";
      };
    };

  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`

  fonts.fontconfig.enable = true;

  home = {

    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
    stateVersion = "24.11";  

    sessionVariables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
      LIBVA_DRIVER_NAME = "iHD";
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

  xresources.properties = { # set cursor size and dpi for your monitor
    "Xcursor.size" = 24;
    "Xft.dpi" = 172;
  };
}

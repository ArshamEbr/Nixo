{ 
  config,
  user, 
  ... 
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      "$crust" = "11111b";
      "$mantle" = "181825";
      "$base" = "1e1e2e";
      "$surface0" = "313244";
      "$surface1" = "45475a";
      "$surface2" = "585b70";
      "$overlay0" = "6c7086";
      "$overlay1" = "7f849c";
      "$text" = "cdd6f4";
      "$subtext0" = "a6adc8";
      "$subtext1" = "bac2de";
      "$lavender" = "b4befe";
      "$blue" = "89b4fa";
      "$sapphire" = "74c7ec";
      "$sky" = "89dceb";
      "$teal" = "94e2d5";
      "$green" = "a6e3a1";
      "$yellow" = "f9e2af";
      "$peach" = "fab387";
      "$maroon" = "eba0ac";
      "$red" = "f38ba8";
      "$mauve" = "cba6f7";
      "$pink" = "f5c2e7";
      "$flamingo" = "f2cdcd";
      "$rosewater" = "f5e0dc";

      background = [
        {
          monitor = "";
          path = "$HOME/nixo/resources/wallpapers/wolf.jpg";
          blur_passes = 4;
          blur_size = 6;
          noise = 0.0117;
          contrast = 0.9;
          brightness = 0.6;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "280, 55";
          outline_thickness = 3;
          dots_size = 0.25;
          dots_spacing = 0.2;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgba(137, 180, 250, 0.4)";
          inner_color = "rgba(17, 17, 27, 0.7)";
          font_color = "rgb($text)";
          font_family = "JetBrains Mono Nerd Font";
          fade_on_empty = false;
          fade_timeout = 1000;
          placeholder_text = "<span foreground='##$overlay1'>Type to unlock...</span>";
          hide_input = false;
          rounding = 14;
          check_color = "rgba(166, 227, 161, 0.6)";
          fail_color = "rgba(243, 139, 168, 0.7)";
          fail_text = "<span foreground='##$red'>Nope! Try again ($ATTEMPTS)</span>";
          fail_timeout = 2000;
          fail_transition = 300;
          capslock_color = "rgba(249, 226, 175, 0.6)";
          numlock_color = "rgba(137, 180, 250, 0.4)";
          bothlock_color = "rgba(203, 166, 247, 0.6)";
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -220";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 8;
          shadow_color = "rgba(137, 180, 250, 0.25)";
          shadow_boost = 1.0;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +'%H'";
          text_align = "center";
          color = "rgb($text)";
          font_size = 160;
          font_family = "JetBrains Mono Nerd Font ExtraBold";
          position = "0, 380";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 15;
          shadow_color = "rgba(137, 180, 250, 0.3)";
          shadow_boost = 1.2;
        }
        {
          monitor = "";
          text = "cmd[update:1000] date +'%M'";
          text_align = "center";
          color = "rgb($lavender)";
          font_size = 160;
          font_family = "JetBrains Mono Nerd Font ExtraBold";
          position = "0, 200";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 15;
          shadow_color = "rgba(203, 166, 247, 0.35)";
          shadow_boost = 1.2;
        }
        {
          monitor = "";
          text = "•";
          text_align = "center";
          color = "rgba(203, 166, 247, 0.6)";
          font_size = 35;
          font_family = "JetBrains Mono Nerd Font";
          position = "-130, 290";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "•";
          text_align = "center";
          color = "rgba(203, 166, 247, 0.6)";
          font_size = 35;
          font_family = "JetBrains Mono Nerd Font";
          position = "130, 290";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] date +'%A'";
          text_align = "center";
          color = "rgb($text)";
          font_size = 16;
          font_family = "JetBrains Mono Nerd Font Medium";
          position = "0, 95";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 6;
          shadow_color = "rgba(180, 190, 254, 0.3)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "cmd[update:60000] date +'%B %d, %Y'";
          text_align = "center";
          color = "rgb($subtext1)";
          font_size = 13;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 65";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 4;
          shadow_color = "rgba(186, 194, 222, 0.25)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "cmd[update:60000] hour=$(date +%H); if [ $hour -lt 6 ]; then echo 'Night owl, ${user.name}?'; elif [ $hour -lt 12 ]; then echo 'Good morning, ${user.name}'; elif [ $hour -lt 17 ]; then echo 'Good afternoon, ${user.name}'; elif [ $hour -lt 21 ]; then echo 'Good evening, ${user.name}'; else echo 'Code time, ${user.name}'; fi";
          text_align = "center";
          color = "rgb($sky)";
          font_size = 14;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -135";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 8;
          shadow_color = "rgba(137, 220, 235, 0.4)";
          shadow_boost = 1.2;
        }
        {
          monitor = "";
          text = "LOCKED";
          text_align = "center";
          color = "rgb($lavender)";
          font_size = 10;
          font_family = "JetBrains Mono Nerd Font Bold";
          position = "0, -170";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 8;
          shadow_color = "rgba(180, 190, 254, 0.4)";
          shadow_boost = 1.2;
        }
        {
          monitor = "";
          text = "cmd[update:10000] cat /sys/class/power_supply/BAT0/capacity 2>/dev/null | xargs -I{} echo '󰁹 {}%' || echo ''";
          text_align = "left";
          color = "rgb($green)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font";
          position = "30, -30";
          halign = "left";
          valign = "top";
          shadow_passes = 2;
          shadow_size = 5;
          shadow_color = "rgba(166, 227, 161, 0.35)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "cmd[update:5000] nmcli -t -f NAME c show --active 2>/dev/null | head -1 | xargs -I{} echo '󰤨 {}' || echo '󰤭 Disconnected'";
          text_align = "left";
          color = "rgb($sky)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font";
          position = "30, -55";
          halign = "left";
          valign = "top";
          shadow_passes = 2;
          shadow_size = 5;
          shadow_color = "rgba(137, 220, 235, 0.35)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "cmd[update:60000] uptime -p | sed 's/up /󰔟  /'";
          text_align = "left";
          color = "rgb($subtext0)";
          font_size = 11;
          font_family = "JetBrains Mono Nerd Font";
          position = "30, 25";
          halign = "left";
          valign = "bottom";
          shadow_passes = 1;
          shadow_size = 4;
          shadow_color = "rgba(166, 173, 200, 0.2)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "󰌌  $LAYOUT";
          text_align = "right";
          color = "rgb($subtext0)";
          font_size = 11;
          font_family = "JetBrains Mono Nerd Font";
          position = "-30, 25";
          halign = "right";
          valign = "bottom";
          shadow_passes = 1;
          shadow_size = 4;
          shadow_color = "rgba(166, 173, 200, 0.2)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          text = "NixOS";
          text_align = "right";
          color = "rgb($sapphire)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font Bold";
          position = "-30, -30";
          halign = "right";
          valign = "top";
          shadow_passes = 2;
          shadow_size = 6;
          shadow_color = "rgba(116, 199, 236, 0.4)";
          shadow_boost = 1.0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "$HOME/.face";
          size = 90;
          rounding = -1;
          border_size = 3;
          border_color = "rgba(137, 180, 250, 0.5)";
          rotate = 0;
          reload_time = -1;
          position = "0, -60";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 10;
          shadow_color = "rgba(180, 190, 254, 0.4)";
          shadow_boost = 1.2;
        }
      ];

      shape = [
        {
          monitor = "";
          size = "360, 240";
          color = "rgba(17, 17, 27, 0.55)";
          rounding = 24;
          border_size = 2;
          border_color = "rgba(137, 180, 250, 0.12)";
          rotate = 0;
          xray = false;
          position = "0, -175";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 15;
          shadow_color = "rgba(203, 166, 247, 0.1)";
          shadow_boost = 1.0;
        }
        {
          monitor = "";
          size = "180, 2";
          color = "rgba(180, 190, 254, 0.2)";
          rounding = 1;
          border_size = 0;
          border_color = "rgba(0, 0, 0, 0)";
          rotate = 0;
          xray = false;
          position = "0, 290";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
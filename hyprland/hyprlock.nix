{config, pkgs, inputs, lib, ... }:
{
programs.hyprlock.enable=true;
programs.hyprlock.settings = {
"$text_color" = "rgba(ECDEECFF)";
"$entry_background_color" = "rgba(18111A11)";
"$entry_border_color" = "rgba(9A8C9C55)";
"$entry_color" = "rgba(D1C2D2FF)";
#"$text_color" = "rgba(FFFFFFFF)";
#"$entry_background_color" = "rgba(33333311)";
#"$entry_border_color" = "rgba(3B3B3B55)";
#"$entry_color" = "rgba(FFFFFFFF)";
"$font_family" = "Rubik Light";
"$font_family_clock" = "Rubik Light";
"$font_material_symbols" = "Material Symbols Rounded";

background = [
  {
    color = [ 
    "rgba(130C15FF)"
    "rgba(000000FF)"
    ];
    path = "/home/arsham/.cache/ags/user/generated/hypr/lockscreen.png";
    # path = screenshot;
    blur_size = 5;
    blur_passes = 4;
  }
];


input-field = [
  {
    monitor = "";
    size = "250, 50";
    outline_thickness = 2;
    dots_size = "0.1";
    dots_spacing = "0.3";
    outer_color = "$entry_border_color";
    inner_color = "$entry_background_color";
    font_color = "$entry_color";
    # fade_on_empty = true;

    position = "0, 20";
    halign = "center";
    valign = "center";
  }
];


label = [
  { # Clock
    monitor = "";
    text = "$TIME";
    shadow_passes = 1;
    shadow_boost = "0.5";
    color = "$text_color";
    font_size = 65;
    font_family = "$font_family_clock";

    position = "0, 300";
    halign = "center";
    valign = "center";
  }
  { # Greeting
    monitor = "";
    text = "hi $USER !!!";
    shadow_passes = 1;
    shadow_boost = "0.5";
    color = "$text_color";
    font_size = 20;
    font_family = "$font_family";

    position = "0, 240";
    halign = "center";
    valign = "center";
  }
  { # lock icon
    monitor = "";
    text = "lock";
    shadow_passes = 1;
    shadow_boost = "0.5";
    color = "$text_color";
    font_size = 21;
    font_family = "$font_material_symbols";

    position = "0, 65";
    halign = "center";
    valign = "bottom";
  }
  { # "locked" text
    monitor = "";
    text = "locked";
    shadow_passes = 1;
    shadow_boost = "0.5";
    color = "$text_color";
    font_size = 14;
    font_family = "$font_family";

    position = "0, 45";
    halign = "center";
    valign = "bottom";
  }
  { # Status
    monitor = "";
    text = "cmd[update:5000] \"\${XDG_CONFIG_HOME:-$HOME}\"/nixo/hyprland/status.sh";
    shadow_passes = 1;
    shadow_boost = "0.5";
    color = "$text_color";
    font_size = 14;
    font_family = "$font_family";

    position = "30, -30";
    halign = "left";
    valign = "top";
  }
];
};
}

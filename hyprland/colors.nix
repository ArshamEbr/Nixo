{config, pkgs, ... }: 
{

wayland.windowManager.hyprland.settings = {


# exec = export SLURP_ARGS='-d -c FFD6F8BB -b 5B3D5844 -s 00000000'

general = {
    "col.active_border" = "rgba(ECDEEC39)";
    "col.inactive_border" = "rgba(9A8C9C30)";
};

misc = {
    background_color = "rgba(18111AFF)";
};

plugin = {
    hyprbars = {
        bar_text_font = "Rubik, Geist, AR One Sans, Reddit Sans, Inter, Roboto, Ubuntu, Noto Sans, sans-serif";
        bar_height = 30;
        bar_padding = 10;
        bar_button_padding = 5;
        bar_precedence_over_border = true;
        bar_part_of_window = true;

        bar_color = "rgba(18111AFF)";
        "col.text" = "rgba(ECDEECFF)";


        # example buttons (R -> L)
        # hyprbars-button = color, size, on-click
        hyprbars-button = "rgb(ECDEEC), 13, 󰖭, hyprctl dispatch killactive";
        hyprbars-button = "rgb(ECDEEC), 13, 󰖯, hyprctl dispatch fullscreen 1";
        hyprbars-button = "rgb(ECDEEC), 13, 󰖰, hyprctl dispatch movetoworkspacesilent special";
    };
};
   };
}
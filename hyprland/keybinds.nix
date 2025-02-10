{config, pkgs, lib, ... }: 
{

wayland.windowManager.hyprland.settings = {

# ################### It just works™ keybinds by Celes Renata (Modified a little by ArshamEbr xD) ###################

# $Secondary is a reference to Command or Win, depending on what is plugged into the computer.

"$Primary" = "SUPER";
"$Secondary" = "CONTROL";
"$Tertiary" = "SHIFT";
"$Alternate" = "ALT";
"$MenuButton" = "MENU";

bindl = [
  # Volume
  ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
  #clipboard
  ",Print,exec,grim - | wl-copy"
  #media
  ", XF86AudioNext, exec, playerctl next"
  ", XF86AudioPrev, exec, playerctl previous"
  ", XF86AudioPlay, exec, playerctl play-pause"
  #lockscreen
  "$Secondary$Tertiary, L, exec, sleep 0.1 && systemctl suspend"

];

bindle = [
  # Volume
  ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
  ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  # Brightness
  # ", XF86MonBrightnessUp, exec, light -A 5"
  # ", XF86MonBrightnessDown, exec, light -U 5"
  ", XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.02;'"
  ", XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.02;'"
  #ags related
  ", XF86AudioRaiseVolume, exec, ags run-js 'indicator.popup(1);'"
  ", XF86AudioLowerVolume, exec, ags run-js 'indicator.popup(1);'"
  ", XF86MonBrightnessUp, exec, ags run-js 'indicator.popup(1);'"
  ", XF86MonBrightnessDown, exec, ags run-js 'indicator.popup(1);'"
];

bindr = [
  #ags related
  "$Primary$Secondary, R, exec, hyprctl reload; pkill ags; pkill activewin.sh; pkill activews.sh; pkill gohypr; pkill bash; pkill ydotool; ~/.local/bin/initialSetup.sh; ags &"
  "$Primary, $Primary_R, exec, ags run-js 'indicator.popup(-1);'"
  "$Primary, $Primary_R, exec, ags run-js 'Notifications.notifications.forEach((notif) => notif.dismiss())'"
  "$Primary, $Primary_R, exec, ags run-js 'App.closeWindow('sideright');'"
  "$Primary, $Primary_R, exec, ags run-js 'App.closeWindow('cheatsheet');'"
  "$Primary, $Primary_R, exec, ags run-js 'App.closeWindow('osk');'"
  "$Primary, $Primary_R, exec, ags run-js 'App.closeWindow('session');'"
  "$Primary, $Primary_R, exec, ags run-js 'openMusic$Primarys.value = false'"
  "$Primary, $Primary_R, exec, ags run-js 'openColorScheme.value = false'"
];

binde = [
  # Window split ratio
  "$Primary$Secondary, Minus, splitratio, -0.1"
  "$Primary$Secondary, Equal, splitratio, 0.1"
  "$Secondary, Semicolon, splitratio, -0.1"
  "$Secondary, Apostrophe, splitratio, 0.1"
];

bindm = [
  # Move/resize windows with $Secondary + LMB/RMB and dragging
  "$Primary, mouse:273, resizewindow"
  "$Primary$Secondary, mouse:273, resizewindow"
  ",mouse:274, movewindow"
  "$Secondary, mouse:273, movewindow"
  "$Primary$Secondary, Z, movewindow"
];

bind = [
  # ####################################### Applications ########################################
  # Apps: just normal apps
  # Music
  #"$Primary$Secondary, M, exec, tidal-hifi"
  #"$Primary$Secondary$Tertiary, M, exec, env -u NIXOS_OZONE_WL cider --use-gl=desktop"
  #"$Primary$Secondary$Alternate, M, exec, spotify" 
  "$Primary, V, exec, amberol"

  # LookingGlass and virsh shortcuts for ease of access
  "$Primary$Alternate, p, exec, dgpu_windows_vm_start.sh"
  "$Primary$Alternate, o, exec, dgpu_windows_vm_shutdown.sh"
  "$Primary$Alternate, i, exec, iaudio_dgpu_windows_vm_start.sh"

  # Power Modes
  "$Primary$Alternate, 0, exec, battery_toggle.sh"
  "$Primary$Alternate, 9, exec, tlp_mode.sh"

  # dGPU Status
  "$Primary$Alternate, 8, exec, check_gpu_status.sh"
  
  # Discord
  "$Primary, 1, exec, vesktop --disable-gpu"
  "$Alternate, 1, exec, discord --disable-gpu"

  # Telegram
  "$Primary, 2, exec, telegram-desktop --disable-gpu"

  # System Monitors
  "$Primary, M, exec, [float; size 50% 56%; move 100%-w-10 43] foot -e btop"
  "$Alternate, M, exec, [float; size 50% 55%; move 100%-w-10 43] kitty -e btop"
  "$Primary$Alternate, M, exec, missioncenter"

  # Foot
  "$Primary, T, exec, foot"
  "$Alternate, T, exec, kitty"
  "$Primary$Secondary, T, exec, kitty -e nmtui"

  # File Explorers
  "$Primary, E, exec, nautilus"
  "$Alternate, E, exec, thunar"

  # Browsers
  "$Primary, B, exec, brave --disable-gpu"
  "$Alternate, B, exec, zen"
  
  # notepad
  "$Primary$Secondary, X, exec, subl"
  "$Primary, C, exec, code --disable-gpu"
  #"$Primary$Secondary$Tertiary, C, exec, jetbrains-toolbox"
  
  # calculator
  #"$Primary$Secondary, 3, exec, ~/.local/bin/wofi-calc"
  ",XF86Calculator, exec, ~/.local/bin/wofi-calc"

  ## Flux
  ##"$Primary$Secondary, N, exec, gammastep -O +3000 &"
  ##"$Primary$Secondary$Alternate, N, exec, gammastep -O +6500 &"

  # Apps: Settings and config
  "$Primary$Secondary, I, exec, XDG_CURRENT_DESKTOP='gnome' gnome-control-center"
  "$Primary$Secondary, V, exec, pavucontrol"
  "$Primary$Tertiary, Home, exec, gnome-system-monitor"
  #"$Primary$Alternate, Insert, exec, foot -F btop"
  
  # Actions
  "$Primary$Secondary, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji"
  "$Alternate, F4, killactive,"
  "$Secondary$Alternate, Space, togglefloating,"
  "$Primary, Q, exec, hyprctl kill"
  "$Primary$Tertiary$Alternate, Delete, exec, pkill wlogout || wlogout -p layer-shell"
  "$Primary$Tertiary$Alternate$Secondary, Delete, exec, systemctl poweroff"
  # "$Tertiary$Alternate,mouse_up, exec, wtype -M ctrl -k Prior"
  # "$Tertiary$Alternate,mouse_down, exec, wtype -M ctrl -k Next"
  
  # Screenshot, Record, OCR, Color picker, Clipboard history
  "$Secondary$Tertiary, D, exec,~/.local/bin/rubyshot | wl-copy"
  "$Secondary$Tertiary, 4, exec, grim -g \"\$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" - | wl-copy"
  "$Secondary$Tertiary, 5, exec, ~/.config/ags/scripts/record-script.sh"
  "$Secondary$Alternate, 5, exec, ~/.config/ags/scripts/record-script.sh --sound"
  "$Secondary$Tertiary$Alternate, 5, exec, ~/.config/ags/scripts/record-script.sh --fullscreen-sound"
  
  "$Secondary$Alternate, C, exec, hyprpicker -a"
  "$Primary$Alternate, Space, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl"
  "$Secondary$Alternate, V, exec, cliphist list | wofi -Iim --dmenu | cliphist decode | wl-copy && wtype -M ctrl v -M ctrl"
  ##"$Primary, Menu, exec, tac ~/.local/share/snippets | wofi -Iim --dmenu | sed -z '$ s/\n$//' | wl-copy && wtype -M ctrl v -M ctrl"
  ##"$Alternate, Menu, exec, wtype -M logo c -M logo && wl-paste >> ~/.local/share/snippets && sed '/^[[:space:]]*$/d' -i ~/.local/share/snippets && notify-send "Added to snippets!""
  ##"$Alternate$Tertiary, Menu, exec, tac ~/.local/share/snippets | wofi -Iim --dmenu | xargs -I '%' ~/.local/bin/regexEscape.sh "'%'"| xargs -I '%' sed '/\(^.*%.*$\)/d' -i ~/.local/share/snippets && notify-send "Deleted from snippets!""
  
  # Image to text
  # Normal
  "$Primary$Secondary$Tertiary,S,exec,grim -g \"\$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" 'tmp.png' && tesseract 'tmp.png' - | wl-copy && rm 'tmp.png'"
  # English
  ##"$Secondary$Tertiary,T,exec,grim -g \"\$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" 'tmp.png' && tesseract -l eng 'tmp.png' - | wl-copy && rm 'tmp.png'"
  # Japanese
  ##"$Secondary$Tertiary,J,exec,grim -g \"\$(slurp -d -c D1E5F4BB -b 1B232866 -s 00000000)\" 'tmp.png' && tesseract -l jpn 'tmp.png' - | wl-copy && rm 'tmp.png'"
  
  # Media
  ##"$Secondary$Tertiary, N, exec, playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`"
  "$Secondary$Tertiary, B, exec, playerctl previous"
  "$Secondary$Tertiary, P, exec, playerctl play-pause"
  
  #Lock screen
  "$Primary$Secondary, L, exec, hyprlock"
  
  
  # App launcher
  "$Primary$Secondary, Slash, exec, pkill anyrun || anyrun"
  
  # ##################################### AGS keybinds #####################################
  
  "$Secondary$Tertiary, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh"
  "$Primary, A, exec, ags -t 'overview'"
  "$Secondary$Alternate, Slash, exec, ~/.local/bin/agsAction.sh cheatsheet"
  "$Secondary, B, exec, ags -t 'sideleft'"
  "$Secondary, N, exec, ags -t 'sideright'"
 # "$Secondary, M, exec, ags run-js 'openMusic$Primarys.value = (!Mpris.getPlayer() ? false : !openMusic$Primarys.value);'"
  "$Secondary, Comma, exec, ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);'"
 # "$Secondary, K, exec, ~/.local/bin/agsAction.sh osk"
  "$Primary$Alternate, Q, exec, ~/.local/bin/agsAction.sh session"
  
  # ##################################### Plugins #########################################
  ##"$Primary$Secondary, P, exec, hyprctl plugin load "~/.config/hypr/plugins/droidbars.so""
  ##"$Primary$Secondary, O, exec, hyprctl plugin unload "~/.config/hypr/plugins/droidbars.so""
  
  # Testing
  # "$Secondary$Alternate, f12, exec, notify-send "Hyprland version: $(hyprctl version | head -2 | tail -1 | cut -f2 -d ' ')" "owo" -a 'Hyprland keybind'"
  ##"$Secondary$Alternate, f12, exec, notify-send "Millis since epoch" "$(date +%s%N | cut -b1-13)" -a 'Hyprland keybind'"
  ##"$Secondary$Alternate, Equal, exec, notify-send "Urgent notification" "Ah hell no" -u critical -a 'Hyprland keybind'"
  
  # ########################### Keybinds for Hyprland ############################
  # Swap windows
  "$Secondary$Tertiary, left, movewindow, l"
  "$Secondary$Tertiary, right, movewindow, r"
  "$Secondary$Tertiary, up, movewindow, u"
  "$Secondary$Tertiary, down, movewindow, d"
  # Move focus
  "$Secondary, left, movefocus, l"
  "$Secondary, right, movefocus, r"
  "$Alternate, up, movefocus, u"
  "$Alternate, down, movefocus, d"
  "$Secondary, BracketLeft, movefocus, l"
  "$Secondary, BracketRight, movefocus, r"
  
  # Workspace, window, tab switch with keyboard
  "$Primary$Secondary, right, workspace, +1"
  "$Primary$Secondary, left, workspace, -1"
  "$Primary$Secondary, BracketLeft, workspace, -1"
  "$Primary$Secondary, BracketRight, workspace, +1"
  "$Primary$Secondary, up, workspace, -5"
  "$Primary$Secondary, down, workspace, +5"
  "$Secondary, Page_Down, workspace, +1"
  "$Secondary, Page_Up, workspace, -1"
  "$Primary$Secondary, Page_Down, workspace, +1"
  "$Primary$Secondary, Page_Up, workspace, -1"
  "$Secondary$Alternate, Page_Down, movetoworkspace, +1"
  "$Secondary$Alternate, Page_Up, movetoworkspace, -1"
  "$Secondary$Tertiary, Page_Down, movetoworkspace, +1"
  "$Secondary$Tertiary, Page_Up, movetoworkspace, -1"
  "$Primary$Secondary$Tertiary, Right, movetoworkspace, +1"
  "$Primary$Secondary$Tertiary, Left, movetoworkspace, -1"
  "$Secondary$Tertiary, mouse_down, movetoworkspace, -1"
  "$Secondary$Tertiary, mouse_up, movetoworkspace, +1"
  "$Secondary$Alternate, mouse_down, movetoworkspace, -1"
  "$Secondary$Alternate, mouse_up, movetoworkspace, +1"
  
  # Fullscreen
  "$Primary$Secondary, F, fullscreen, 0"
  "$Primary$Secondary, D, fullscreen, 1"
  #"$Secondary$Alternate, F, fakefullscreen, 0"
  
  # Switching
  "$Secondary, 1, workspace, 1"
  "$Secondary, 2, workspace, 2"
  "$Secondary, 3, workspace, 3"
  "$Secondary, 4, workspace, 4"
  "$Secondary, 5, workspace, 5"
  "$Secondary, 6, workspace, 6"
  "$Secondary, 7, workspace, 7"
  "$Secondary, 8, workspace, 8"
  "$Secondary, 9, workspace, 9"
  "$Secondary, 0, workspace, 10"
  "$Primary$Secondary, S, togglespecialworkspace,"
  "$Alternate, Tab, cyclenext"
  "$Alternate, Tab, bringactivetotop,"  # bring it to the top
  
  # Move window to workspace $Secondary + $Alternate + [0-9] 
  "$Secondary $Alternate, 1, movetoworkspacesilent, 1"
  "$Secondary $Alternate, 2, movetoworkspacesilent, 2"
  "$Secondary $Alternate, 3, movetoworkspacesilent, 3"
  "$Secondary $Alternate, 4, movetoworkspacesilent, 4"
  "$Secondary $Alternate, 5, movetoworkspacesilent, 5"
  "$Secondary $Alternate, 6, movetoworkspacesilent, 6"
  "$Secondary $Alternate, 7, movetoworkspacesilent, 7"
  "$Secondary $Alternate, 8, movetoworkspacesilent, 8"
  "$Secondary $Alternate, 9, movetoworkspacesilent, 9"
  "$Secondary $Alternate, 0, movetoworkspacesilent, 10"
  "$Primary$Tertiary$Secondary, Up, movetoworkspacesilent, special"
  "$Secondary$Alternate, S, movetoworkspacesilent, special"
  
  # Scroll through existing workspaces with ($Primary) + $Secondary + scroll
  "$Secondary, mouse_up, workspace, +1"
  "$Secondary, mouse_down, workspace, -1"
  "$Primary$Secondary, mouse_up, workspace, +1"
  "$Primary$Secondary, mouse_down, workspace, -1"
  
  # Move/resize windows with $Secondary + LMB/RMB and dragging
  "Primary$Secondary, Backslash, resizeactive, exact 640 480"
  
  "Secondary$Alternate, J, exec, ydotool key 105:1 105:0 "
  ];
 };
}
   
   

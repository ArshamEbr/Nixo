{config, pkgs, inputs, lib, ... }:
{
services.hypridle.enable=true;
services.hypridle.settings = {

"$lock_cmd" = "pidof hyprlock || hyprlock";
"$suspend_cmd" = "pidof steam || systemctl suspend || loginctl suspend"; # fuck nvidia

general = {
    lock_cmd = "$lock_cmd";
    before_sleep_cmd = "loginctl lock-session";
};

listener = [
  {
    timeout = 180; # 3mins
    on-timeout = "brightnessctl | grep 'Current' | awk '{ print $3 }' > ~/.cache/idle-brightness && brightnessctl set 1%";
    on-resume = "brightnessctl set $(cat ~/.cache/idle-brightness)";
  }
  {
    timeout = 420; # 7mins
    on-timeout = "$lock_cmd";
  }
  {
    timeout = 600; # 10mins
    on-timeout = "hyprctl dispatch dpms off";
    on-resume = "hyprctl dispatch dpms on";
  }
#  {
#    timeout = 540 # 9mins
#    on-timeout = $suspend_cmd
#  }
];
};
}
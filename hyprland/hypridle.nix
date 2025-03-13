{config, pkgs, inputs, lib, ... }:
{
 services =  {

   hypridle.enable=true;

   hypridle.settings = {

    "$lock_cmd" = "pidof hyprlock || hyprlock";
    "$suspend_cmd" = "pidof steam || pidof looking-glass-client || systemctl suspend || loginctl suspend"; # fuck nvidia
    "$dpms_state_file" = "/tmp/dpms_off";
    
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
        timeout = 600; # 10 mins
         on-timeout = ''
           [ -f "$dpms_state_file" ] || { hyprctl dispatch dpms off && touch "$dpms_state_file"; }
         '';
         on-resume = ''
           [ ! -f "$dpms_state_file" ] || { hyprctl dispatch dpms on && rm -f "$dpms_state_file"; }
         '';
      }
   
    {
      timeout = 7200; # 2 hours
      on-timeout = "$suspend_cmd";
    }
     
     ];
   };
 };
}
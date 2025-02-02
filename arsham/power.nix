{ config, pkgs, ... }:
{
  powerManagement.powertop.enable = false;                     # enable powertop auto tuning on startup.
  services = {
    system76-scheduler.settings.cfsProfiles.enable = true;     # Better scheduling for CPU cycles - thanks System76!!!
    power-profiles-daemon.enable = false;                      # Disable GNOMEs L power management 
    thermald.enable = true;                                    # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
    tlp = {                                                    # Enable TLP (better than gnomes internal power manager)
      enable = true;
      settings = { # sudo tlp-stat
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_SCALING_MIN_FREQ_ON_AC = 400000;  # 400 MHz # 1155g7 intel core i5 11th gen so
        CPU_SCALING_MAX_FREQ_ON_AC = 4500000; # 4,5 GHz # change it for your hardware limit
        START_CHARGE_THRESH_BAT0 = 0; # dummy value                                             sudo tlp setcharge 0 1 -> Conservation on
        STOP_CHARGE_THRESH_BAT0 = 1; # set it to 1 for conservation mode or 0 for full charge.  sudo tlp setcharge 0 0 -> Conservation off 
      };
    };
  };
}
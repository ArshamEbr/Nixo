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
        SCHED_POWERSAVE_ON_AC = 0;
        SCHED_POWERSAVE_ON_BAT = 1;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 90;
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
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RUNTIME_PM_DRIVER_BLACKLIST = "mei_me iTCO_wdt";
        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersupersave";
        NVIDIA_GPU_POWER_ON_AC = "on";
        NVIDIA_GPU_POWER_ON_BAT = "off";
        USB_AUTOSUSPEND = 1;
        USB_AUTOSUSPEND_BLACKLIST = "input";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        DISK_IDLE_SECS_ON_AC = "60";
        DISK_IDLE_SECS_ON_BAT = "2";
        SATA_LINKPWR_ON_AC = "max_performance"; # "med_power_with_dipm" keep in mind
        SATA_LINKPWR_ON_BAT = "min_power";
        DISK_IOSCHED = "none none";
        WIFI_PWR_ON_AC = "1";
        WIFI_PWR_ON_BAT = "5";
        SOUND_POWER_SAVE_ON_AC = "0";
        SOUND_POWER_SAVE_ON_BAT = "1";
        SOUND_POWER_SAVE_CONTROLLER = "Y";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth wifi";
      };
    };
  };
}
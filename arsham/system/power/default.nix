/**
Configures system power management settings in NixOS.

Enables powertop auto-tuning and TLP for advanced power management,
disables GNOME's power-profiles-daemon and thermald, and sets detailed
TLP parameters for CPU, GPU, disk, and device power optimization.
*/

{
  pkgs,
  ... 
}:

{
  powerManagement.powertop.enable = true;
  
  services = {
    system76-scheduler.settings.cfsProfiles.enable = true;     # Better scheduling for CPU cycles
    power-profiles-daemon.enable = false;
    thermald.enable = false;                                   # only if on Intel CPUs
    tlp = {
      enable = true;
      settings = { # TODO change these based on your system! run "sudo tlp-stat"   
        
        # Scheduler power saving: 0=off, 1=on
        SCHED_POWERSAVE_ON_AC = 0;   # Disable scheduler power saving on AC
        SCHED_POWERSAVE_ON_BAT = 1;  # Enable scheduler power saving on battery
        
        # CPU performance limits (percent)
        CPU_MIN_PERF_ON_AC = 0;      # Minimum CPU performance on AC
        CPU_MAX_PERF_ON_AC = 100;    # Maximum CPU performance on AC
        CPU_MIN_PERF_ON_BAT = 0;     # Minimum CPU performance on battery
        CPU_MAX_PERF_ON_BAT = 90;    # Maximum CPU performance on battery
        
        # Intel GPU frequency settings (MHz)
        INTEL_GPU_MIN_FREQ_ON_AC = "1250";   # Minimum GPU freq on AC
        INTEL_GPU_MIN_FREQ_ON_BAT = "100";   # Minimum GPU freq on battery
        INTEL_GPU_MAX_FREQ_ON_AC = "1350";   # Maximum GPU freq on AC
        INTEL_GPU_MAX_FREQ_ON_BAT = "900";   # Maximum GPU freq on battery
        INTEL_GPU_BOOST_FREQ_ON_AC = "1350"; # Boost GPU freq on AC
        INTEL_GPU_BOOST_FREQ_ON_BAT = "1000";# Boost GPU freq on battery
        
        # CPU boost and dynamic boost
        CPU_BOOST_ON_AC = 1;         # Enable CPU turbo boost on AC
        CPU_BOOST_ON_BAT = 0;        # Disable CPU turbo boost on battery
        CPU_HWP_DYN_BOOST_ON_AC = 1; # Enable hardware P-state dynamic boost on AC
        CPU_HWP_DYN_BOOST_ON_BAT = 0;# Disable hardware P-state dynamic boost on battery
        
        # CPU governor and energy policy
        CPU_SCALING_GOVERNOR_ON_AC = "performance";      # Governor on AC
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";       # Governor on battery
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";    # Energy policy on AC
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power"; # Energy policy on battery
        
        # CPU frequency limits (kHz) - adjust for your hardware!
        CPU_SCALING_MIN_FREQ_ON_AC = 2500000;  # Minimum CPU freq on AC (e.g., 2.5 GHz)
        CPU_SCALING_MAX_FREQ_ON_AC = 4500000;  # Maximum CPU freq on AC (e.g., 4.5 GHz)
        CPU_SCALING_MIN_FREQ_ON_BAT = 400000;  # Minimum CPU freq on battery (e.g., 400 MHz)
        CPU_SCALING_MAX_FREQ_ON_BAT = 2500000; # Maximum CPU freq on battery (e.g., 2.5 GHz)
        
        # Battery charge thresholds (dummy values, adjust as needed)
        START_CHARGE_THRESH_BAT0 = 0; # Start charging threshold for BAT0
        STOP_CHARGE_THRESH_BAT0 = 0;  # Stop charging threshold for BAT0
        
        # Runtime power management
        RUNTIME_PM_ON_AC = "auto";                       # Enable runtime PM on AC
        RUNTIME_PM_ON_BAT = "auto";                      # Enable runtime PM on battery
        RUNTIME_PM_DRIVER_BLACKLIST = "mei_me iTCO_wdt"; # Drivers to exclude from runtime PM
        
        # PCIe Active State Power Management
        PCIE_ASPM_ON_AC = "performance";     # ASPM policy on AC
        PCIE_ASPM_ON_BAT = "powersupersave"; # ASPM policy on battery
        
        # NVIDIA GPU power management
        NVIDIA_GPU_POWER_ON_AC = "on";   # Power on NVIDIA GPU on AC
        NVIDIA_GPU_POWER_ON_BAT = "off"; # Power off NVIDIA GPU on battery
        
        # USB autosuspend
        USB_AUTOSUSPEND = 1;                 # Enable USB autosuspend
        USB_AUTOSUSPEND_BLACKLIST = "input"; # Exclude input devices from autosuspend
        USB_EXCLUDE_PHONE = 1;               # Don't autosuspend phones
        USB_EXCLUDE_PRINTER = 1;             # Don't autosuspend printers
        
        # Platform profile (if supported)
        PLATFORM_PROFILE_ON_AC = "performance"; # Platform profile on AC
        PLATFORM_PROFILE_ON_BAT = "low-power";  # Platform profile on battery
        
        # Disk settings
        DISK_IDLE_SECS_ON_AC = "60";              # Disk idle timeout on AC (seconds)
        DISK_IDLE_SECS_ON_BAT = "2";              # Disk idle timeout on battery (seconds)
        SATA_LINKPWR_ON_AC = "max_performance";   # SATA link power management on AC
        SATA_LINKPWR_ON_BAT = "min_power";        # SATA link power management on battery
        DISK_IOSCHED = "mq-deadline mq-deadline"; # Disk I/O scheduler
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";
        DISK_DEVICES = "ata-WDC_WDBNCE5000PNC_20294J442712"; # TODO change this using tlp diskid
        
        # WiFi power saving
        WIFI_PWR_ON_AC = "off";    # Disable WiFi power saving on AC
        WIFI_PWR_ON_BAT = "on";    # Enable WiFi power saving on battery
        
        # Network power management
        WOL_DISABLE = "Y";  # Disable Wake-on-LAN if not needed
        
        # Miscellaneous
        NMI_WATCHDOG = "0";                # Disable NMI watchdog
        SOUND_POWER_SAVE_ON_AC = "0";      # Disable sound power saving on AC
        SOUND_POWER_SAVE_ON_BAT = "1";     # Enable sound power saving on battery
        SOUND_POWER_SAVE_CONTROLLER = "Y"; # Enable sound controller power saving
        
        # Device management
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";           # Disable Bluetooth at startup
        DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";    # Disable Bluetooth on battery if not in use
        DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth wifi";     # Disable Bluetooth and WiFi on shutdown
      };
    };
  };
}
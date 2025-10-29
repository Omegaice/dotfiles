{
  powerManagement = {
    enable = true;

    powertop = {
      enable = false;
    };
  };

  # Intel thermal daemon - prevents thermal throttling
  # Uses DPTF (Dynamic Platform & Thermal Framework) for Tiger Lake
  # Note: T15g has Lenovo DYTC, so we need --ignore-cpuid-check
  services.thermald = {
    enable = true;
    ignoreCpuidCheck = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      # CPU governor (fallback - Intel P-states EPP is preferred)
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Intel P-states Energy Performance Preference (EPP)
      # This is the primary performance/power control mechanism
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power"; # Changed from "powersave"

      # CPU performance percentages
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Turbo Boost control
      CPU_BOOST_ON_AC = 1;  # Enabled on AC (free performance)
      CPU_BOOST_ON_BAT = 0; # Disabled on battery (huge power draw)

      # Battery charge thresholds (preserve battery longevity)
      # Charging to 100% accelerates degradation
      START_CHARGE_THRESH_BAT0 = 75; # Start charging at 75%
      STOP_CHARGE_THRESH_BAT0 = 90;  # Stop charging at 90%

      # Platform profile (ACPI firmware hints)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Intel iGPU frequency scaling
      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MAX_FREQ_ON_AC = 1450;
      INTEL_GPU_MIN_FREQ_ON_BAT = 350;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1450;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1450;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1450;

      # Runtime power management
      RUNTIME_PM_ON_AC = "on";   # Keep devices active on AC
      RUNTIME_PM_ON_BAT = "auto"; # Aggressive power saving on battery

      # PCIe Active State Power Management
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # WiFi power saving
      WIFI_PWR_ON_AC = "off"; # Full performance on AC
      WIFI_PWR_ON_BAT = "on"; # Power save on battery

      # USB autosuspend (enable for battery savings)
      USB_AUTOSUSPEND = 1;
      USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = 1;

      # Audio codec power saving
      SOUND_POWER_SAVE_ON_AC = 0;  # No timeout on AC (avoid pops/clicks)
      SOUND_POWER_SAVE_ON_BAT = 1; # 1 second timeout on battery

      # Disk/NVMe power management
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
    };
  };
}

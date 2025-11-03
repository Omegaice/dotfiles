# Intel WiFi (iwlwifi) Driver Configuration
# Applies to: Intel AX210, AX211, AX200, 9260, etc.
#
# Fixes suspend/resume issues where WiFi firmware crashes on resume from S3 sleep
# with ADVANCED_SYSASSERT errors. These parameters disable power-saving features
# that are known to cause firmware instability during suspend/resume cycles.

{
  boot.kernelParams = [
    # Disable WiFi power save mode to prevent firmware crashes on resume
    # Trade-off: Slightly higher power consumption for reliable suspend/resume
    "iwlwifi.power_save=0"

    # Disable U-APSD (Unscheduled Automatic Power Save Delivery)
    # Value 3 = disable for both BSS (infrastructure) and P2P Client modes
    # This prevents D0i3 low-power state issues that cause firmware hangs
    "iwlwifi.uapsd_disable=3"
  ];
}

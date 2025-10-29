{
  # systemd-logind configuration for laptop power management
  # Controls lid close, power button, and idle behavior

  services.logind = {
    # Lid switch behavior
    lidSwitch = "suspend"; # Suspend when lid closes
    lidSwitchDocked = "ignore"; # Don't suspend when external display connected
    lidSwitchExternalPower = "suspend"; # Still suspend on AC (saves power)

    # Power button behavior
    powerKey = "suspend"; # Short press suspends
    powerKeyLongPress = "poweroff"; # Long press (hold for 5s) powers off
  };

  # Enable S3 suspend (deep sleep) instead of s2idle
  # S3 is more reliable and uses less power on ThinkPads
  boot.kernelParams = [
    "mem_sleep_default=deep" # Force S3 suspend
  ];
}

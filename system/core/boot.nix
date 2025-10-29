{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel parameters for power management and hardware support
    kernelParams = [
      # Intel P-states (native CPU frequency driver)
      "intel_pstate=active" # Use Intel P-states instead of ACPI cpufreq
    ];

    # ThinkPad-specific kernel modules
    kernelModules = ["thinkpad_acpi"]; # Enables battery thresholds, LEDs, fan control
  };
}

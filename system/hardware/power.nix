{
  powerManagement = {
    enable = true;

    powertop = {
      enable = false;
    };
  };

  services.thermald = {
    enable = false;
  };

  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      # Intel GPU
      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MAX_FREQ_ON_AC = 1450;
      INTEL_GPU_MIN_FREQ_ON_BAT = 350;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1450;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1450;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1450;

      # USB
      USB_AUTOSUSPEND = 0;
    };
  };
}

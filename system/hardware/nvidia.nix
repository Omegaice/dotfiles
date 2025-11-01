{pkgs, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Proprietary driver has better performance/stability than open
    open = false;

    modesetting.enable = false;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      # PCI bus IDs from: lspci | grep VGA
      # 00:02.0 = Intel UHD Graphics
      # 01:00.0 = NVIDIA RTX 3080 Mobile
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload wrapper command
      };

      sync.enable = false; # Sync mode keeps dGPU always powered on
    };
  };

  # Kernel parameters automatically added by NixOS nvidia module:
  # - nvidia.NVreg_PreserveVideoMemoryAllocations=1 (from powerManagement.enable)
  # - nvidia-drm.modeset=1 (from prime.offload.enable OR modesetting.enable)
  # - nvidia-drm.fbdev=1 (driver >= 545)
  #
  # Note: nvidia-drm.modeset=1 keeps nvidia-drm driver loaded, preventing full
  # GPU power-down. This is a NixOS design requirement for PRIME offload mode.

  environment.systemPackages = with pkgs; [
    mesa-demos # glxinfo/glxgears for testing
    #nvtopPackages.full # GPU monitoring (NVIDIA + Intel)
  ];
}

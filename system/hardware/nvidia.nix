{pkgs, ...}: {
  # Enable NVIDIA proprietary drivers
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Use proprietary driver (better performance/stability than open)
    open = false;

    # Enable power management for better battery life
    powerManagement = {
      enable = true;
      finegrained = false;
    };

    # Hybrid graphics: PRIME sync mode
    # Both Intel iGPU and NVIDIA dGPU active simultaneously
    # Display output from NVIDIA, synchronized with Intel for better compatibility
    prime = {
      offload.enable = false;
      sync.enable = true;
    };
  };

  # Preserve video memory allocations across suspend/resume
  # Required for NVIDIA GPU to properly resume from sleep
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

  # NVIDIA GPU monitoring and diagnostic tools
  environment.systemPackages = with pkgs; [
    mesa-demos # glxinfo/glxgears - OpenGL/Vulkan info and testing
    nvtopPackages.full # Real-time GPU monitoring for both NVIDIA and Intel GPUs
  ];
}

# Intel Integrated Graphics (iGPU) Configuration
# Generic configuration for Intel integrated GPUs

{ config, lib, pkgs, ... }: {
  # === CPU Configuration ===

  # Enable Intel microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # === Intel iGPU Configuration ===

  # Load Intel GPU module in initrd for early KMS
  boot.initrd.kernelModules = [ "i915" ];

  # Enable GuC firmware for i915 driver (improves power management)
  # GuC = Graphics microController - handles power/freq management
  boot.kernelParams = [ "i915.enable_guc=3" ];

  # Hardware video acceleration packages
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver     # VAAPI driver for video decode/encode (Gen 8+)
    intel-compute-runtime  # OpenCL support
    vpl-gpu-rt             # Intel VPL (Video Processing Library)
  ];

  # 32-bit support for Steam/Wine
  hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
    intel-media-driver
  ];
}

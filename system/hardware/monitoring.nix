{pkgs, ...}: {
  # Hardware monitoring and diagnostic tools
  # These tools help monitor hardware health and performance
  environment.systemPackages = with pkgs; [
    # Storage health monitoring
    nvme-cli # NVMe SSD management and health monitoring (nvme smart-log)
    smartmontools # S.M.A.R.T. disk monitoring (smartctl - requires root)

    # Network diagnostics
    ethtool # Ethernet adapter info (link speed, driver info)

    # Thermal and power monitoring
    lm_sensors # Temperature sensors for CPU/GPU/motherboard (sensors command)
    acpi # Battery and power status (acpi -b for battery info)
  ];
}

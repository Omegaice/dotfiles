{pkgs, ...}: {
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };
  };

  services.resolved = {
    enable = true;
  };

  # Disable NetworkManager-wait-online to speed up boot
  # This service blocks boot until network is fully connected, which is unnecessary
  # unless you have network filesystems or other boot-time network dependencies
  systemd.services.NetworkManager-wait-online.enable = false;
}

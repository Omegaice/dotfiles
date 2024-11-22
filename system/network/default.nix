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

#  systemd = {
#    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
#    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
#  };
}

{ pkgs, ... }:
{
  # Thunderbolt device management
  # Bolt is a userspace daemon for Thunderbolt 3/4 security and device authorization
  # Works with any desktop environment (not just GNOME)
  services.hardware.bolt.enable = true;

  # Thunderbolt CLI management tool
  environment.systemPackages = with pkgs; [
    bolt # boltctl - CLI for managing Thunderbolt devices
  ];
}

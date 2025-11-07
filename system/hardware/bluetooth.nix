{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    package = pkgs.bluez5-experimental;
  };

  services.blueman = {
    enable = true;
  };
}

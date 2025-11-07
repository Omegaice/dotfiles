{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;

    # Disable as we use uwsm
    systemd.enable = false;
  };

  # uwsm environment variables for Hyprland
  xdg.configFile."uwsm/env-hyprland".text = ''
    # Multi-GPU configuration for Hyprland
    # Intel (card1) primary for power savings - has internal display (eDP-1)
    # NVIDIA (card0) secondary - has external display (DP-9 via Thunderbolt dock)
    # Both cards listed so Hyprland can use displays on either GPU
    export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"
  '';
}

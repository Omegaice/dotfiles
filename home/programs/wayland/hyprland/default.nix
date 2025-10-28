{
  inputs,
  pkgs,
  ...
}: {
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
}

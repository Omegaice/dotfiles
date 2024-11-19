{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./binds.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;

    systemd = {
      enable = false;
    };
  };
}

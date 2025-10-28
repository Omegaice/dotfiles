{
  inputs,
  pkgs,
  ...
}: {
  # enable hyprland and required options
  programs.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    withUWSM = true;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = {};

  environment.systemPackages = [
    inputs.hyprpolkitagent.packages.${pkgs.system}.hyprpolkitagent
    pkgs.libva-utils # vainfo - verify NVIDIA VA-API hardware acceleration works with Hyprland
  ];

  # tell Electron/Chromium to run on Wayland
  # environment.variables.NIXOS_OZONE_WL = "1";
}

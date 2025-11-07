{
  lib,
  config,
  ...
}:
{
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        comment = "Hyprland session managed by UWSM";
        prettyName = "Hyprland";
      };
    };
  };
}

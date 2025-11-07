{
  lib,
  pkgs,
  config,
  ...
}:
let
  hyprland-conf = pkgs.writeText "hyprland-regreet-config" ''
    exec-once = "${lib.getExe config.programs.regreet.package}"
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
        command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
        user = "omegaice";
        # command = "${lib.getExe config.programs.hyprland.package} --config ${hyprland-conf}";
      };
    };
  };

  # programs.regreet.enable = false;
}

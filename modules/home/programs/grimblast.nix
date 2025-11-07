{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.grimblast = {
    enable = mkEnableOption "grimblast, a screenshot utility for Hyprland";

    package = mkPackageOption pkgs "grimblast" { };

    saveLocation = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "~/Pictures/Screenshots";
      description = ''
        Directory where screenshots will be saved.

        If not set, grimblast will use XDG user directories defaults
        (typically `$XDG_PICTURES_DIR` or `~/Pictures`).
      '';
    };

    defaultFlags = mkOption {
      type = types.listOf types.str;
      default = [
        "--notify"
        "--cursor"
      ];
      example = [
        "--notify"
        "--cursor"
        "--freeze"
      ];
      description = ''
        Default flags to pass to grimblast commands.
        Common options: --notify, --cursor, --freeze, --wait N, --scale
      '';
    };
  };

  config =
    let
      cfg = config.programs.grimblast;
    in
    mkIf cfg.enable {
      home.packages = [ cfg.package ];

      # Create custom screenshot directory if specified
      # Otherwise grimblast uses XDG Pictures directory by default
      home.activation.createScreenshotsDir = mkIf (cfg.saveLocation != null) (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "${cfg.saveLocation}"
        ''
      );
    };
}

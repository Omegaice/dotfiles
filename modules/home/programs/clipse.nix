{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.clipse;
  jsonFormat = pkgs.formats.json {};
in {
  options.programs.clipse = {
    enable = mkEnableOption "clipse, a configurable TUI clipboard manager for Unix";

    package = mkPackageOption pkgs "clipse" {};

    maxHistory = mkOption {
      type = types.int;
      default = 100;
      description = "Maximum number of clipboard entries to retain in history.";
    };

    allowDuplicates = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow duplicate entries in clipboard history.";
    };

    settings = mkOption {
      type = jsonFormat.type;
      default = {};
      example = literalExpression ''
        {
          imageDisplay = {
            type = "native";
            scaleX = 0.5;
            scaleY = 0.5;
          };
        }
      '';
      description = ''
        Additional configuration for clipse.

        These settings are merged with the default configuration.
        See <https://github.com/savedra1/clipse#configuration> for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # Generate config.json if any settings are specified
    xdg.configFile."clipse/config.json" = mkIf (cfg.settings != {} || cfg.maxHistory != 100 || !cfg.allowDuplicates) {
      source = jsonFormat.generate "clipse-config" (
        {
          maxHistory = cfg.maxHistory;
          allowDuplicates = cfg.allowDuplicates;
        }
        // cfg.settings
      );
    };
  };
}

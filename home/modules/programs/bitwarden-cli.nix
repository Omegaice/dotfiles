{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  jsonFormat = pkgs.formats.json {};
in {
  options.programs.bitwarden-cli = {
    enable = mkEnableOption "Secure and free password manager for all of your devices.";

    package = mkPackageOption pkgs "bitwarden-cli" {};

    baseServer = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "On-premises hosted installation URL";
    };

    webVault = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Provides a custom web vault URL that differs from the base URL";
    };
  };

  config = let
    cfg = config.programs.bitwarden-cli;
    settings = {
      stateVersion = 68;
      global_environment_environment = {
        region = "Self-hosted";
        urls = {
          base = cfg.baseServer;
          api = null;
          identity = null;
          webVault = cfg.webVault;
          icons = null;
          notifications = null;
          events = null;
          keyConnector = null;
        };
      };
    };
  in
    mkIf cfg.enable {
      home.packages = [cfg.package];

      xdg.configFile."Bitwarden CLI/data.json" = {
        source = jsonFormat.generate "bitwarden-cli-config" settings;
      };

      # home.activation.writeBitwardenCliConfig = let
      #   configPath = "${config.xdg.configHome}/Bitwarden CLI/data.json";
      # in {
      #   after = ["writeBoundary"];
      #   before = [];
      #   data = ''
      #     install -m 0640 "$(readlink ${configPath})" ${configPath}
      #   '';
      # };
    };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.programs.duf = {
    enable = mkEnableOption "a better {command}`df` alternative";

    enableBashIntegration =
      mkEnableOption "Bash integration"
      // {
        default = true;
      };

    enableZshIntegration =
      mkEnableOption "Zsh integration"
      // {
        default = true;
      };

    enableFishIntegration =
      mkEnableOption "Fish integration"
      // {
        default = true;
      };

    enableIonIntegration =
      mkEnableOption "Ion integration"
      // {
        default = true;
      };

    enableNushellIntegration = mkEnableOption "Nushell integration";

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra command line options passed to duf.
      '';
    };

    package = mkPackageOption pkgs "duf" {};
  };

  config = let
    cfg = config.programs.duf;

    args = escapeShellArgs (cfg.extraOptions);

    optionsAlias = optionalAttrs (args != "") {eza = "duf ${args}";};

    aliases = builtins.mapAttrs (_name: value: lib.mkDefault value) {
      df = "duf";
    };
  in
    mkIf cfg.enable {
      home.packages = [cfg.package];

      programs.bash.shellAliases =
        optionsAlias
        // optionalAttrs cfg.enableBashIntegration aliases;

      programs.zsh.shellAliases =
        optionsAlias
        // optionalAttrs cfg.enableZshIntegration aliases;

      programs.fish = mkMerge [
        (mkIf (!config.programs.fish.preferAbbrs) {
          shellAliases =
            optionsAlias
            // optionalAttrs cfg.enableFishIntegration aliases;
        })

        (mkIf config.programs.fish.preferAbbrs {
          shellAliases = optionsAlias;
          shellAbbrs = optionalAttrs cfg.enableFishIntegration aliases;
        })
      ];

      programs.ion.shellAliases =
        optionsAlias
        // optionalAttrs cfg.enableIonIntegration aliases;

      programs.nushell.shellAliases =
        optionsAlias
        // optionalAttrs cfg.enableNushellIntegration aliases;
    };
}

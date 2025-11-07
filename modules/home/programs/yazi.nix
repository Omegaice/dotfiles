{
  config,
  lib,
  pkgs,
  yaziPlugins,
  ...
}:
with lib;
let
  cfg = config.programs.yazi;

  # Plugin submodule type
  pluginType = types.submodule (
    { config, ... }:
    {
      options = {
        plugin = mkOption {
          type = types.package;
          example = lib.literalExpression "yaziPlugins.allmytoes";
          description = "The yazi plugin package to install.";
        };

        setup = mkOption {
          type = types.lines;
          default = "";
          example = ''
            require("allmytoes"):setup {
              sizes = {"n", "l", "x", "xx"}
            }
          '';
          description = ''
            Lua code to run in init.lua for plugin setup.
            This will be executed after the plugin is loaded.
          '';
        };

        previewers = mkOption {
          type = types.nullOr (types.listOf (types.either types.str types.attrs));
          default = null;
          example = lib.literalExpression ''
            [
              "image/*"
              { name = "*.mkv"; mime = "video/*"; }
            ]
          '';
          description = ''
            Override the plugin's default previewer configuration.

            Each entry can be:
            - String: "image/*" (shorthand for { mime = "image/*"; })
            - Attrset: { name = "*.raf"; mime = "image/*"; }

            If null (default), uses the plugin's built-in metadata.
            If set, replaces the plugin's previewer metadata entirely.
          '';
        };

        preloaders = mkOption {
          type = types.nullOr (types.listOf (types.either types.str types.attrs));
          default = null;
          example = lib.literalExpression ''
            [
              "video/*"
              { mime = "video/*"; prio = "high"; }
            ]
          '';
          description = ''
            Override the plugin's default preloader configuration.

            Each entry can be:
            - String: "video/*" (shorthand for { mime = "video/*"; })
            - Attrset: { mime = "video/*"; prio = "high"; cond = "..."; }

            If null (default), uses the plugin's built-in metadata.
            If set, replaces the plugin's preloader metadata entirely.
          '';
        };
      };
    }
  );

  # Normalize plugins to attrset format
  normalizePlugin =
    p:
    if types.package.check p then
      {
        plugin = p;
        setup = "";
        previewers = null;
        preloaders = null;
      }
    else
      p;

  # Get all plugins and their dependencies
  normalizedPlugins = map normalizePlugin cfg.pluginConfig;
  pluginPackages = map (p: p.plugin) normalizedPlugins;
  pluginDeps = flatten (map (p: p.runtimeInputs or [ ]) pluginPackages);

  # Extract auto-configuration from plugins with override support
  # For each plugin, use explicit override if provided, otherwise fall back to plugin metadata
  extractPreviewers =
    p:
    if p.previewers != null then
      p.previewers # User override
    else
      p.plugin.yaziPreviewers or [ ]; # Plugin metadata

  extractPreloaders =
    p:
    if p.preloaders != null then
      p.preloaders # User override
    else
      p.plugin.yaziPreloaders or [ ]; # Plugin metadata

  pluginPreviewers = flatten (map extractPreviewers normalizedPlugins);
  pluginPreloaders = flatten (map extractPreloaders normalizedPlugins);

  # Generate init.lua from plugin setups
  pluginSetups = concatMapStringsSep "\n\n" (
    p:
    optionalString (p.setup != "") ''
      -- Setup for ${p.plugin.pname or "plugin"}
      ${p.setup}
    ''
  ) normalizedPlugins;

  # Generate init.lua from plugin setups only
  # Note: HM's built-in initLua option is separate and will be merged
  initLuaContent = optionalString (pluginSetups != "") ''
    -- Plugin setup (managed by Nix)
    ${pluginSetups}
  '';
in
{
  options.programs.yazi = {
    pluginConfig = mkOption {
      type = types.listOf (types.either types.package pluginType);
      default = [ ];
      example = literalExpression ''
        with yaziPlugins; [
          glow
          hexyl
          {
            plugin = allmytoes;
            setup = '''
              require("allmytoes"):setup {
                sizes = {"n", "l", "x", "xx"}
              }
            ''';
            previewers = ["image/*"];
            preloaders = ["image/*"];
          }
        ]
      '';
      description = ''
        Advanced plugin configuration with auto-generated setup.

        Extends Home Manager's built-in `programs.yazi.plugins` with:
        - Per-plugin Lua setup code (auto-generates init.lua)
        - Auto-configuration of previewers/preloaders (auto-generates yazi.toml)
        - Automatic runtime dependency installation

        Can be either:
        - A plugin package: `yaziPlugins.glow`
        - An attrset with plugin and setup code:
          ```nix
          {
            plugin = yaziPlugins.allmytoes;
            setup = "require('allmytoes'):setup {}";
            previewers = ["image/*"];
            preloaders = ["image/*"];
          }
          ```

        Note: For simple plugin installation without configuration,
        use Home Manager's built-in `programs.yazi.plugins` instead.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Install plugin runtime dependencies
    home.packages = pluginDeps;

    # Install plugins to .config/yazi/plugins/
    home.file = listToAttrs (
      map (plugin: {
        name = ".config/yazi/plugins/${plugin.yaziPluginName or plugin.pname}.yazi";
        value = {
          source = plugin;
        };
      }) pluginPackages
    );

    # Prepend plugin setup to Home Manager's initLua
    programs.yazi.initLua = mkIf (initLuaContent != "") (mkBefore initLuaContent);

    # Auto-configure previewers and preloaders from plugin metadata
    # If you don't want auto-config, simply omit previewers/preloaders from plugin definition
    programs.yazi.settings.plugin = {
      prepend_previewers = mkOptionDefault pluginPreviewers;
      prepend_preloaders = mkOptionDefault pluginPreloaders;
    };
  };
}

{
  lib,
  stdenv,
}:
{
  pname,
  version,
  src,
  # Plugin metadata
  yaziPlugin ? pname, # Plugin name (defaults to pname)
  # Dependencies that must be in PATH
  runtimeInputs ? [],
  # Auto-configuration for yazi.toml [plugin] section
  # Previewers: handles file preview rendering
  # Each entry can be:
  #   - String: "image/*" (shorthand for { mime = "image/*"; })
  #   - Attrset: { name = "*.raf"; mime = "image/*"; run = "custom"; }
  # Fields: name (filename glob), mime (MIME glob), run (plugin name, defaults to yaziPlugin)
  previewers ? [],
  # Preloaders: handles background file loading
  # Each entry can be:
  #   - String: "image/*" (shorthand for { mime = "image/*"; })
  #   - Attrset: { mime = "video/*"; run = "video"; prio = "high"; cond = "..."; }
  # Fields: name, mime, run (defaults to yaziPlugin), prio (low/normal/high), cond (expression)
  preloaders ? [],
  # Standard derivation args
  ...
}@args: let
  # Remove our custom args from stdenv.mkDerivation
  cleanedArgs = removeAttrs args [
    "yaziPlugin"
    "runtimeInputs"
    "previewers"
    "preloaders"
  ];

  # Normalize previewer entries
  # Accepts: "image/*" or { name = "*.foo"; mime = "image/*"; run = "custom"; }
  normalizePreviewer = entry:
    if builtins.isString entry
    then {
      mime = entry;
      run = yaziPlugin;
    }
    else
      entry
      // {
        run = entry.run or yaziPlugin;
      };

  # Normalize preloader entries
  # Accepts: "image/*" or { mime = "image/*"; run = "custom"; prio = "high"; cond = "..."; }
  normalizePreloader = entry:
    if builtins.isString entry
    then {
      mime = entry;
      run = yaziPlugin;
    }
    else
      entry
      // {
        run = entry.run or yaziPlugin;
      };
in
  stdenv.mkDerivation (cleanedArgs // {
    pname = "yazi-${pname}";
    inherit version;

    # No build phase - plugins are just Lua files
    dontBuild = true;

    # Install to $out/ (not $out/share/...)
    # Yazi expects plugins at ~/.config/yazi/plugins/NAME.yazi/
    installPhase =
      args.installPhase
      or ''
        runHook preInstall

        mkdir -p $out
        cp -r $src/* $out/

        runHook postInstall
      '';

    # Mark runtime dependencies and yazi configuration for Home Manager
    # Using passthru so HM module can extract them
    passthru =
      {
        inherit runtimeInputs;
        yaziPluginName = yaziPlugin;
        # Auto-configuration metadata for yazi.toml [plugin] section
        yaziPreviewers = map normalizePreviewer previewers;
        yaziPreloaders = map normalizePreloader preloaders;
      }
      // (args.passthru or {});

    meta =
      {
        platforms = lib.platforms.all;
      }
      // (args.meta or {});
  })

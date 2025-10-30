{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.allmytoes;

  yamlFormat = pkgs.formats.yaml { };

  # Provider submodule type
  providerModule = types.submodule {
    options = {
      mimes = mkOption {
        type = types.listOf types.str;
        description = "List of MIME types handled by this provider.";
        example = [ "image/x-sony-arw" "image/x-canon-cr2" ];
      };

      commands = mkOption {
        type = types.listOf types.lines;
        description = ''
          List of commands to try (in order) for thumbnail generation.
          Uses allmytoes template variables: %(file)s, %(size)s, %(outfile)s, %(tmpdir)s
        '';
        example = literalExpression ''
          [
            "exiftool -b -PreviewImage \"%(file)s\" | magick - -thumbnail %(size)sx%(size)s \"%(outfile)s\""
          ]
        '';
      };

      meta = mkOption {
        type = types.attrsOf (types.listOf types.lines);
        default = { };
        description = "Metadata extraction commands for freedesktop.org thumbnail spec.";
        example = literalExpression ''
          {
            "Thumb::Document::Pages" = [
              "pdfinfo \"%(file)s\" | awk '/^Pages:/ {print $2}'"
            ];
          }
        '';
      };

      revision = mkOption {
        type = types.int;
        default = 1;
        description = "Provider revision number (increment to force thumbnail regeneration).";
      };
    };
  };

  # Custom providers only - allmytoes will use built-in defaults for unconfigured types
  allProviders = attrValues cfg.providers;

  # MIME types for thumbnailer registration: common image formats + custom providers
  thumbnailerMimeTypes = unique (
    # Common formats handled by allmytoes built-in providers
    [
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/webp"
      "image/tiff"
      "image/bmp"
      "image/svg+xml"
      "image/heif"
      "image/heic"
      "image/avif"
    ]
    # Add MIME types from custom providers
    ++ flatten (map (p: p.mimes) allProviders)
  );

in
{
  meta.maintainers = [ ];

  options.programs.allmytoes = {
    enable = mkEnableOption "AllMyToes thumbnail generator";

    package = mkPackageOption pkgs "allmytoes" { };

    providers = mkOption {
      type = types.attrsOf providerModule;
      default = { };
      description = ''
        Custom thumbnail providers to add or override.

        Each provider specifies MIME types it handles and commands to generate thumbnails.

        When no custom providers are configured, allmytoes uses its built-in defaults
        for common formats (JPEG, PNG, GIF, WebP, TIFF, etc.).

        Custom providers are checked first, with allmytoes falling back to built-in
        providers for unmatched MIME types.
      '';
      example = literalExpression ''
        {
          myCustom = {
            mimes = [ "application/x-custom" ];
            commands = [ "custom-thumbnailer \"%(file)s\" \"%(outfile)s\"" ];
            revision = 1;
          };
        }
      '';
    };

    thumbnailer = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Register allmytoes as freedesktop.org thumbnailer for file managers
          (Nautilus, Dolphin, Thunar, etc).
        '';
      };

      mimeTypes = mkOption {
        type = types.listOf types.str;
        description = ''
          MIME types to register for thumbnailer.
          Automatically populated from enabled providers.
        '';
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Base configuration
    {
      home.packages = [ cfg.package ];

      # Generate provider configuration YAML only if custom providers are defined
      # Otherwise allmytoes uses its built-in defaults
      xdg.configFile."allmytoes/provider.yaml" = mkIf (cfg.providers != {}) {
        source = yamlFormat.generate "allmytoes-providers.yaml" allProviders;
      };

      # Auto-populate thumbnailer MIME types from providers
      programs.allmytoes.thumbnailer.mimeTypes = mkDefault thumbnailerMimeTypes;
    }

    # Freedesktop thumbnailer integration
    (mkIf cfg.thumbnailer.enable {
      xdg.dataFile."thumbnailers/allmytoes.thumbnailer".text =
        let
          wrapper = pkgs.writeShellScript "allmytoes-thumbnailer" ''
            INPUT="$1"
            SIZE="$2"
            OUTPUT="$3"

            # allmytoes returns path to cached thumbnail
            THUMB=$(${lib.getExe cfg.package} "$INPUT" -s "$SIZE" 2>/dev/null)

            if [ -n "$THUMB" ] && [ -f "$THUMB" ]; then
              cp "$THUMB" "$OUTPUT"
              exit 0
            fi
            exit 1
          '';
        in
        ''
          [Thumbnailer Entry]
          TryExec=${lib.getExe cfg.package}
          Exec=${wrapper} %i %s %o
          MimeType=${concatStringsSep ";" cfg.thumbnailer.mimeTypes};
        '';
    })
  ]);
}

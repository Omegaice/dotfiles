{
  lib,
  pkgs,
  callPackage,
  allmytoes,
}:
# Use makeScope for extensibility
lib.makeScope pkgs.newScope (self: {
  # Builder
  buildYaziPlugin = callPackage ./build-yazi-plugin.nix { };

  # Plugins
  allmytoes = self.buildYaziPlugin {
    pname = "allmytoes";
    version = "unstable-2024-10-29";

    src = pkgs.fetchFromGitHub {
      owner = "Sonico98";
      repo = "allmytoes.yazi";
      rev = "master";
      hash = "sha256-FD2kzmavY+xSQEnuNnDmGwI92mA1K6LMX/LXFRdewI0=";
    };

    runtimeInputs = [ allmytoes ];

    # Note: previewers/preloaders should be configured per-user based on
    # programs.allmytoes.thumbnailer.mimeTypes (which includes custom providers)
    # See home/terminal/programs/yazi.nix for the configuration

    # Custom install due to our patched version
    # Fix for yazi v25.5.28+ API changes:
    # - preview_widgets() -> preview_widget() (singular)
    # - Handle errors from ya.image_show()
    # - Strip file:// prefix from URLs before passing to allmytoes
    installPhase = ''
      mkdir -p $out
      cp ${./yazi-allmytoes-main.lua} $out/main.lua
    '';

    meta = {
      description = "AllMyToes thumbnail preview plugin for yazi";
      homepage = "https://github.com/Sonico98/allmytoes.yazi";
      license = lib.licenses.mit;
    };
  };

  glow = self.buildYaziPlugin {
    pname = "glow";
    version = "unstable-2024-10-04";

    src = pkgs.fetchFromGitHub {
      owner = "Reledia";
      repo = "glow.yazi";
      rev = "d8b36ff0113e73a400891726dc2eca8b3c049dea";
      hash = "sha256-fKJ5ld5xc6HsM/h5j73GABB5i3nmcwWCs+QSdDPA9cU=";
    };

    runtimeInputs = [ pkgs.glow ];

    meta = {
      description = "Glow markdown preview plugin for yazi";
      homepage = "https://github.com/Reledia/glow.yazi";
      license = lib.licenses.mit;
    };
  };

  hexyl = self.buildYaziPlugin {
    pname = "hexyl";
    version = "unstable-2024-10-16";

    src = pkgs.fetchFromGitHub {
      owner = "Reledia";
      repo = "hexyl.yazi";
      rev = "ccc0a4a959bea14dbe8f2b243793aacd697e34e2";
      hash = "sha256-9rPJcgMYtSY5lYnFQp3bAhaOBdNUkBaN1uMrjen6Z8g=";
    };

    runtimeInputs = [ pkgs.hexyl ];

    meta = {
      description = "Hexyl hex viewer plugin for yazi";
      homepage = "https://github.com/Reledia/hexyl.yazi";
      license = lib.licenses.mit;
    };
  };
})

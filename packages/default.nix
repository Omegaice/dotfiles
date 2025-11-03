{inputs, ...}: {
  perSystem = {
    config,
    self',
    inputs',
    system,
    pkgs,
    ...
  }: {
    # Define packages first
    packages = let
      # Standalone tools
      allmytoes = pkgs.callPackage ./allmytoes.nix {};
      nw-generate-launcher = pkgs.callPackage ./nw-generate-launcher.nix {};

      # Yazi plugin scope (for use in home-manager)
      # Not exported as a package since it's a scope, not a derivation
      yaziPlugins = pkgs.callPackage ./yazi-plugins {
        inherit allmytoes;
      };
    in {
      pdm = pkgs.pdm.overrideAttrs (prev: {
        postUnpack =
          (prev.postUnpack or "")
          + ''
            substituteInPlace $sourceRoot/src/pdm/project/config.py --replace 'default="virtualenv"' 'default="venv"'
          '';
      });

      inherit allmytoes nw-generate-launcher;

      # Export individual yazi plugins (nix flake show)
      yazi-allmytoes = yaziPlugins.allmytoes;
      yazi-glow = yaziPlugins.glow;
      yazi-hexyl = yaziPlugins.hexyl;
    };

    # Export yaziPlugins scope separately for use in specialArgs
    # This allows home-manager modules to access it
    _module.args.yaziPlugins = let
      allmytoes = config.packages.allmytoes;
    in
      pkgs.callPackage ./yazi-plugins {
        inherit allmytoes;
      };
  };
}

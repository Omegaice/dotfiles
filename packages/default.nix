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
    packages = {
      pdm = pkgs.pdm.overrideAttrs (prev: {
        postUnpack =
          (prev.postUnpack or "")
          + ''
            substituteInPlace $sourceRoot/src/pdm/project/config.py --replace 'default="virtualenv"' 'default="venv"'
          '';
      });

      allmytoes = pkgs.callPackage ./allmytoes.nix {};
      yazi-allmytoes = pkgs.callPackage ./yazi-allmytoes.nix {
        allmytoes = config.packages.allmytoes;
      };
      yazi-glow = pkgs.callPackage ./yazi-glow.nix {};
      yazi-hexyl = pkgs.callPackage ./yazi-hexyl.nix {};
    };
  };
}

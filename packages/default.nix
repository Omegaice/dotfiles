{inputs, ...}: {
  perSystem = {
    config,
    self',
    inputs',
    system,
    pkgs,
    final,
    ...
  }: {
    overlayAttrs = {
      pdm = pkgs.pdm.overrideAttrs (prev: {
        postUnpack =
          (prev.postUnpack or "")
          + ''
            substituteInPlace $sourceRoot/src/pdm/project/config.py --replace 'default="virtualenv"' 'default="venv"'
          '';
      });

      yazi-glow = pkgs.callPackage ./yazi-glow.nix {};
      yazi-hexyl = pkgs.callPackage ./yazi-hexyl.nix {};

      pythonPackagesExtensions =
        pkgs.pythonPackagesExtensions
        ++ [
          (pself: pprev: {
          })
        ];
    };

    packages = {
      inherit (final) pdm yazi-glow yazi-hexyl;
    };
  };
}

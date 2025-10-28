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

      yazi-glow = pkgs.callPackage ./yazi-glow.nix {};
      yazi-hexyl = pkgs.callPackage ./yazi-hexyl.nix {};
    };

    # Then export them as overlay attributes (for easyOverlay)
    overlayAttrs = {
      inherit (config.packages) pdm yazi-glow yazi-hexyl;

      pythonPackagesExtensions =
        pkgs.pythonPackagesExtensions
        ++ [
          (pself: pprev: {
          })
        ];
    };
  };
}

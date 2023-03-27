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
      pdm = pkgs.callPackage ./pdm/default.nix {};

      pythonPackagesExtensions =
        pkgs.pythonPackagesExtensions
        ++ [
          (pself: pprev: {
          })
        ];
    };

    packages.pdm = final.pdm;
  };
}

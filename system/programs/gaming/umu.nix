{
  inputs,
  pkgs,
  ...
}: let
  umu = inputs.umu.packages.${pkgs.system}.umu-launcher.override {
    withTruststore = true;
    withDeltaUpdates = true;
  };
in {
  environment.systemPackages = [
    umu
  ];
}

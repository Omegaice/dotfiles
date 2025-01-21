{
  inputs,
  inputs',
  pkgs,
  ...
}: let
  umu = inputs'.umu.packages.umu.override {
    version = inputs.umu.shortRev;
    truststore = true;
    cbor2 = true;
  };
in {
  environment.systemPackages = [
    umu
  ];
}

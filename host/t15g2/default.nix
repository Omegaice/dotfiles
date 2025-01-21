{
  flake-parts-lib,
  self,
  withSystem,
  ...
}: let
  inherit (flake-parts-lib) importApply;
in {
  imports = [
    ./deploy.nix
    ./nixosConfiguration.nix
  ];

  # flake.nixosConfigurations.t15g2 = importApply ./nixosConfiguration.nix {
  #   localFlake = self;
  #   inherit withSystem;
  # };
}
# nixpkgs = import inputs.nixpkgs {
#       config.cudaSupport = true;
#     };


{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    t15g2 = nixosSystem {
      inherit specialArgs;
      modules = [
        ./hardware-configuration.nix
        ../../system/core/boot.nix
        ../../system/core/default.nix
        ../../system/hardware/bluetooth.nix
        ../../system/hardware/fwupd.nix
        ../../system/nix/default.nix
      ];

      networking.hostName = "t15g2"; # Define your hostname.
    };
  };
}

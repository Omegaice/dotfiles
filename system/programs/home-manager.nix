{
  inputs,
  packages,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    # Pass extra arguments to Home Manager modules
    extraSpecialArgs = {
      # Make yaziPlugins available to home-manager modules
      yaziPlugins = let
        allmytoes = packages.allmytoes;
        pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
      in
        pkgs.callPackage ../../packages/yazi-plugins {
          inherit allmytoes;
        };
      # Pass packages for convenience
      inherit packages;
    };
  };
}

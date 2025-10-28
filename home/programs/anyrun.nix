{
  pkgs,
  inputs,
  ...
}: {
  # Note: Home Manager now has built-in anyrun support (added Oct 1, 2025)
  # No need to import inputs.anyrun.homeManagerModules.default anymore

  programs.anyrun = {
    enable = true;
    package = inputs.anyrun.packages.${pkgs.system}.anyrun;

    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
    };
  };
}

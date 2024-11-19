{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;

    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
    };
  };
}

{pkgs, inputs, ...}: let
  unstablePkgs = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  programs.claude-code = {
    enable = true;
    package = unstablePkgs.claude-code;
  };
}

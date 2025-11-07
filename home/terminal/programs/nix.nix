{ pkgs, ... }:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    cachix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}

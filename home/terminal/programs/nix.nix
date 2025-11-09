{ pkgs, ... }:
# nix tooling
{
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixfmt-tree
    deadnix
    statix
    cachix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}

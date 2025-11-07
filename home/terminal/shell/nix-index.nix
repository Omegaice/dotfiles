{ inputs, ... }:
{
  imports = [
    inputs.nix-index-db.homeModules.nix-index
  ];
  programs.nix-index.enable = true;
}

{inputs, ...}: {
  imports = [
    inputs.nix-index-db.hmModules.nix-index
  ];
  programs.nix-index.enable = true;
}
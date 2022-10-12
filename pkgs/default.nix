self: super: {
  salt-lint = super.callPackage ./salt-lint/default.nix {
    inherit (super) lib python3;
  };
}

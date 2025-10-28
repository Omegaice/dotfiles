{...}: {
  # Shell enhancements - universal tools that work with any shell
  imports = [
    ./atuin.nix      # Shell history enhancer
    ./nix-index.nix  # nix-locate functionality
    ./starship.nix   # Modern cross-shell prompt
    ./zoxide.nix     # Smart directory jumping
  ];
}

{...}: {
  # Core terminal environment - consistent across all hosts
  # Includes: modern CLI tools, shell enhancements, system monitors
  # Excludes: terminal emulators (choose per-host), shells (choose per-host)
  imports = [
    ./programs  # CLI toolkit: git, bat, eza, rg, jq, btop, zellij, claude-code, etc.
    ./shell     # Shell enhancements: starship, zoxide, nix-index
  ];
}

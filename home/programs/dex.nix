{pkgs, ...}: {
  # Desktop entry execution tool
  # Used for launching .desktop files from CLI/scripts
  home.packages = with pkgs; [
    dex
  ];
}

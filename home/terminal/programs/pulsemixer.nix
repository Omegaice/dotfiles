{pkgs, ...}: {
  # PulseAudio/PipeWire TUI volume mixer
  home.packages = with pkgs; [
    pulsemixer  # ncurses-based volume control for terminal
  ];
}

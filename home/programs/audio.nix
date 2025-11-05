{pkgs, ...}: {
  # Audio control and enhancement tools
  home.packages = with pkgs; [
    # Volume control
    pwvucontrol  # Modern PipeWire volume control (successor to pavucontrol)

    # Audio routing and monitoring
    qpwgraph     # Visual PipeWire graph/patchbay (Qt-based, like qjackctl)
    # helvum     # Alternative: GTK-based graph view (lighter but less features)

    # Audio enhancement suite
    easyeffects  # Audio effects: EQ, compressor, noise reduction, reverb
                 # Useful for: improving laptop speakers, noise suppression for calls,
                 # Bluetooth headphone EQ, bass boost, etc.
  ];

  # EasyEffects service - runs in background to apply audio effects
  services.easyeffects = {
    enable = true;
    # Preset files can be added to ~/.config/easyeffects/output/ or input/
  };
}

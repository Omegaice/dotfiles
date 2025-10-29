{...}: {
  services.swayosd = {
    enable = true;

    # Optional: Position OSD at top of screen (0.9 = 90% from top)
    # Adjust between 0.0 (top) and 1.0 (bottom)
    # null = default center position
    topMargin = 0.9;

    # Optional: Custom CSS styling
    # Set to null to use default styling (good starting point)
    # You can customize later by creating a CSS file
    stylePath = null;
  };
}

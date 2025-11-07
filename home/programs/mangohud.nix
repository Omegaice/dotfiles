{
  # MangoHud performance overlay configuration
  # Usage:
  #   Steam: Enable in Steam launch options: mangohud %command%
  #   Native: mangohud ./game
  #   Toggle overlay: Shift+F12 (default)

  programs.mangohud = {
    enable = true;

    settings = {
      # Core performance metrics
      fps = true;
      frametime = true;
      frame_timing = 1; # Show frametime graph

      # GPU monitoring
      gpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_load_value = "60,90"; # Color thresholds (orange, red)
      gpu_load_color = "FFFFFF,FFAA7F,CC0000"; # white, orange, red

      # CPU monitoring (minimal - focus on GPU)
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      core_load = false; # Don't show individual cores (too cluttered)

      # VRAM usage
      vram = true;
      ram = true;

      # Thermal monitoring
      temp_fahrenheit = false; # Celsius

      # Display position and appearance
      position = "top-left";
      table_columns = 3;
      background_alpha = 0.5;
      font_size = 24;

      # Toggle keybinding
      toggle_hud = "Shift_R+F12";
      toggle_fps_limit = "Shift_L+F1";

      # FPS limiting (for testing)
      fps_limit = "0,60,120,144"; # Cycle through limits with Shift+F1

      # Logging (disabled by default, enable for benchmarking)
      output_folder = "/tmp";
      log_duration = 0; # Don't auto-log

      # Gamemode integration
      gamemode = true;

      # Vulkan/OpenGL
      gl_vsync = -1; # Don't override game settings
    };
  };
}

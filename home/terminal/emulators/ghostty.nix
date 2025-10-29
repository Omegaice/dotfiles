{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      theme = "Catppuccin Mocha";
      window-padding-x = 10;
      window-padding-y = 10;
      cursor-style = "block";
      shell-integration-features = "no-cursor";

      # Systemd: quit 5min after last window closes to save memory while idle
      # but still provide fast launches (~20ms) when service is running
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
    };
  };
}

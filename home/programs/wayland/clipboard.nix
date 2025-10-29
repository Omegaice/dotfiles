{pkgs, ...}: {
  # wl-clipboard required for Wayland clipboard operations
  home.packages = with pkgs; [
    wl-clipboard
  ];

  # Clipse TUI clipboard manager
  # Daemon runs via exec-once in Hyprland (settings.nix)
  # Access with Super+V keybinding
  programs.clipse = {
    enable = true;
    maxHistory = 100;
    allowDuplicates = false;

    # Use Kitty graphics protocol for image previews
    # Ghostty supports Kitty protocol for inline image display
    # scaleX/scaleY are integers - adjust based on your terminal size
    settings = {
      imageDisplay = {
        type = "kitty";
        scaleX = 18;
        scaleY = 30;
        heightCut = 2;
      };
    };
  };
}

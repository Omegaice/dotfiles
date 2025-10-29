{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Firefox
      "noblur, class:(firefox)"

      # Make Zoom Meetings Fullscreen
      "float, class:(zoom), title:(Zoom Workplace)"
      # "fullscreen, class:(zoom), title:(Zoom Workplace)"

      # Digikam
      "float, class:(org.kde.digikam), title:(Images on SD / MMC Card Reader.*)"

      # Clipse clipboard manager - floating TUI window
      # Size: 960x540 (16:9 aspect ratio matching desktop displays)
      "float, class:(com.clipse)"
      "size 960 540, class:(com.clipse)"
    ];
  };
}

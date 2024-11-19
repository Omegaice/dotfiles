{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = false;
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-right = [
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
      };
    };
  };
}

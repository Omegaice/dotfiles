{pkgs, ...}: {
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    settings = {
      global = {
        # Use icon theme for notifications
        icon_theme = "Adwaita";
        enable_recursive_icon_lookup = true;

        # Icon position and size
        icon_position = "left";
        max_icon_size = 48;
      };
    };
  };
}

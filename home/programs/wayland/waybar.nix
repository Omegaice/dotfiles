{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = [
          "network"
          "backlight"
          "privacy"
          "pulseaudio"
          "clock"
          "battery"
          "tray"
        ];

        "hyprland/window" = {
          format = "{class}";
          max-length = 20;
        };

        clock = {
          format = "{:%H:%M}  ";
          timezone = "America/Indiana/Indianapolis";
        };

        network = {
          format = "{ifname}";
          format-wifi = "  {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = "";
          tooltip-format-wifi = "{signalStrength}%";
          max-length = 20;
        };

        battery = {
          interval = 1;
          states = {
            good = 99;
            warning = 30;
            critical = 20;
          };
          format-icons = [" " " " " " " " " "];
          format = "<span color='#8ec07c' > {icon}</span>{capacity}%";
          format-critical = "<span color='#cc241d' > {icon}</span>{capacity}%";
          format-warning = "<span color='#d8a657' > {icon}</span>{capacity}%";
          format-full = "<span color='#8ec07c' > {icon}</span>{capacity}%";
          format-charging = "<span color='#8ec07c' > 󰂅 </span>{capacity}%";
          format-charging-warning = "<span color='#d8a657' > 󰢝 </span>{capacity}%";
          format-charging-critical = "<span color='#cc241d' > 󰢜 </span>{capacity}%";
          format-plugged = "<span color='#8ec07c' > 󰂅 </span>{capacity}%";
          format-alt = "<span color='#8ec07c' > 󱧥 </span>{time}";
          tooltip = false;
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };
      };
    };
  };
}

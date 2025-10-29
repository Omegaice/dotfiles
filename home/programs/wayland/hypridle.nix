{
  inputs,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.default;

    settings = {
      general = {
        # Lock command to execute when locking is requested
        lock_cmd = "pidof hyprlock || hyprlock";

        # Command to run before sleep
        before_sleep_cmd = "loginctl lock-session";

        # Command to run after sleep (turn display back on)
        after_sleep_cmd = "hyprctl dispatch dpms on";

        # Ignore dbus-inhibit (allow idle even if apps request inhibit)
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Dim screen after 5 minutes of inactivity
        {
          timeout = 300; # 5 minutes
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        # Turn off screen after 10 minutes of inactivity
        {
          timeout = 600; # 10 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Lock screen after 15 minutes of inactivity
        {
          timeout = 900; # 15 minutes
          on-timeout = "loginctl lock-session";
        }

        # Suspend system after 30 minutes of inactivity
        # This is conservative - only happens if you've been idle for 30min
        {
          timeout = 1800; # 30 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

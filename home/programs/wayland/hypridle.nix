{
  inputs,
  pkgs,
  ...
}:
let
  # Power state checks
  onBattery = ''[ "$(cat /sys/class/power_supply/AC*/online)" = "0" ]'';
  onAC = ''[ "$(cat /sys/class/power_supply/AC*/online)" = "1" ]'';

  # Actions
  dimScreen = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
  restoreBrightness = "${pkgs.brightnessctl}/bin/brightnessctl -r";
  screenOff = "hyprctl dispatch dpms off";
  screenOn = "hyprctl dispatch dpms on";
  lockSession = "loginctl lock-session";
  suspend = "systemctl suspend";
in
{
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
        # === BATTERY PROFILE: 5/10/15/30 min ===

        # Dim screen after 5 minutes on BATTERY
        {
          timeout = 300;
          on-timeout = ''${onBattery} && ${dimScreen}'';
          on-resume = restoreBrightness;
        }

        # Turn off screen after 10 minutes on BATTERY
        {
          timeout = 600;
          on-timeout = ''${onBattery} && ${screenOff}'';
          on-resume = screenOn;
        }

        # Lock screen after 15 minutes on BATTERY
        {
          timeout = 900;
          on-timeout = ''${onBattery} && ${lockSession}'';
        }

        # Suspend after 30 minutes on BATTERY ONLY
        {
          timeout = 1800;
          on-timeout = ''${onBattery} && ${suspend}'';
        }

        # === AC POWER PROFILE: 10/15/20/never ===

        # Dim screen after 10 minutes on AC
        {
          timeout = 600;
          on-timeout = ''${onAC} && ${dimScreen}'';
          on-resume = restoreBrightness;
        }

        # Turn off screen after 15 minutes on AC
        {
          timeout = 900;
          on-timeout = ''${onAC} && ${screenOff}'';
          on-resume = screenOn;
        }

        # Lock screen after 20 minutes on AC
        {
          timeout = 1200;
          on-timeout = ''${onAC} && ${lockSession}'';
        }

        # Never suspend on AC (no listener for AC suspend)
      ];
    };
  };
}

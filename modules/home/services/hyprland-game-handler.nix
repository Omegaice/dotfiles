{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.hyprland-game-handler;
in {
  options.services.hyprland-game-handler = {
    enable = mkEnableOption "Hyprland game window handler";
  };

  config = mkIf cfg.enable {
    systemd.user.services.hyprland-game-handler = {
      Unit = {
        Description = "Hyprland game window management handler";
        Documentation = "https://wiki.hypr.land/Configuring/Window-Rules/#dynamic-rules";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
      };

      Service = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "hyprland-game-handler" ''
          handle() {
            case $1 in
              windowtitle*)
                # Extract window address from event
                # Format: windowtitle>>ADDRESS
                window_addr=$(echo "$1" | cut -d'>' -f3)

                # Get window info
                window_info=$(${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq --arg addr "0x$window_addr" '.[] | select(.address == $addr)')

                if [ -z "$window_info" ]; then
                  return
                fi

                # Extract class and workspace
                window_class=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.class')
                workspace_name=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.workspace.name')

                # Check if it's an NW.js game not on special:game
                if [[ "$window_class" == "nw-game" ]] && [[ "$workspace_name" != "special:game" ]]; then
                  # Move to special:game workspace and show it
                  ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace special:game,address:0x$window_addr
                  ${pkgs.hyprland}/bin/hyprctl dispatch togglespecialworkspace game
                fi
                ;;
            esac
          }

          # Listen to Hyprland socket for events
          SOCKET_PATH="/run/user/$(id -u)/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
          ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:$SOCKET_PATH | while read -r line; do
            handle "$line"
          done
        '';
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      inline_height = "16";
      filter_mode_shell_up_key_binding = "directory";
      daemon = {
        enabled = true;
        systemd_socket = true;
        socket_path = "${config.xdg.dataHome}/atuin/atuin.sock";
      };
    };
  };

  # Override config to add history_filter with proper backslash escaping
  # Write config directly as text to avoid TOML generator escaping issues
  # Note: ''\\ in Nix multiline string → \ in file (TOML escaped backslash)
  xdg.configFile."atuin/config.toml" = lib.mkForce {
    text = ''
      style = "compact"
      inline_height = 16
      filter_mode_shell_up_key_binding = "directory"

      # Filter out weird pasting errors (ESC[200~ bracketed paste escape sequence)
      history_filter = ["\\[200~"]

      [daemon]
      enabled = true
      systemd_socket = true
      socket_path = "${config.xdg.dataHome}/atuin/atuin.sock"
    '';
  };

  systemd.user = {
    sockets.atuin-daemon = {
      Unit = {
        Description = "Unix socket activation for Atuin daemon";
      };

      Socket = {
        ListenStream = "%h/.local/share/atuin/atuin.sock";
        SocketMode = "0600";
        RemoveOnStop = true;
      };

      Install = {
        WantedBy = [ "socket.target" ];
      };
    };

    services.atuin-daemon = {
      Unit = {
        Description = "Atuin daemon";
        Requires = [ "atuin-daemon.socket" ];
      };

      Service = {
        ExecStart = "${lib.getExe config.programs.atuin.package} daemon";
        Environment = [ "ATUIN_LOG=info" ];
        Restart = "on-failure";
        RestartSteps = 3;
        RestartMaxDelaySec = 6;
      };

      Install = {
        Also = [ "atuin-daemon.socket" ];
        WantedBy = [ "default.target" ];
      };
    };
  };
}

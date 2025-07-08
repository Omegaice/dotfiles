{
  lib,
  config,
  pkgs,
  ...
}: {
  xdg.configFile."atuin/config.toml" = let
    cfg = config.programs.atuin;
    tomlFormat = pkgs.formats.toml {};
  in
    lib.mkForce {
      text = lib.replaceStrings ["\\\\"] ["\\"] (builtins.readFile (tomlFormat.generate "atuin-config" cfg.settings));
    };

  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      inline_height = "16";
      history_filter = [
        # Weird pasting errors
        "\\\\[200~"
      ];
      filter_mode_shell_up_key_binding = "directory";
      daemon = {
        enabled = true;
        systemd_socket = true;
        socket_path = "${config.xdg.dataHome}/atuin/atuin.sock";
      };
    };
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
        WantedBy = ["socket.target"];
      };
    };

    services.atuin-daemon = {
      Unit = {
        Description = "Atuin daemon";
        Requires = ["atuin-daemon.socket"];
      };

      Service = {
        ExecStart = "${lib.getExe config.programs.atuin.package} daemon";
        Environment = ["ATUIN_LOG=info"];
        Restart = "on-failure";
        RestartSteps = 3;
        RestartMaxDelaySec = 6;
      };

      Install = {
        Also = ["atuin-daemon.socket"];
        WantedBy = ["default.target"];
      };
    };
  };
}

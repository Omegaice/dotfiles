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
    };
  };
}

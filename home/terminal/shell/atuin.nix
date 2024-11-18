{
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

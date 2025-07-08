{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      pane_frames = false;
      default_layout = "compact";
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };
}

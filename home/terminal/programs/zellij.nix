{
  programs.zellij = {
    enable = true;
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

{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = [];

    settings = {
      theme = "zed_onedark";
      editor = {
        text-width = 120;
        soft-wrap.enable = true;
        color-modes = true;
        completion-trigger-len = 1;
        completion-replace = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        lsp.display-inlay-hints = true;
        statusline.center = ["position-percentage"];
        true-color = true;
      };
    };
  };
}

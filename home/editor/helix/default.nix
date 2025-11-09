{
  inputs,
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      # Nix - you constantly edit system configs
      nixd # Modern Nix LSP
      nixfmt-rfc-style # Official Nix formatter

      # Shell - for system script editing
      nodePackages.bash-language-server
      shellcheck
      shfmt

      # Project-specific tools (rust, markdown, toml, etc.) should be
      # defined in per-project flake.nix devShells and loaded via direnv
    ];

    # Hide build artifacts and Nix outputs from file picker
    ignores = [
      ".git/"
      ".direnv/"
      "result"
      "result-*"
      "target/" # Rust builds
      "node_modules/"
      ".cache/"
    ];

    # Language-specific configuration
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
            args = [ "--quiet" ];
          };
        }
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "shfmt";
            args = [
              "-i"
              "2"
            ]; # 2-space indentation
          };
        }
      ];
    };

    settings = {
      theme = "zed_onedark";
      editor = {
        # Display and visual
        scrolloff = 5; # Keep 5 lines above/below cursor
        line-number = "relative"; # Relative line numbers for vim-style navigation
        cursorline = true;
        color-modes = true;
        true-color = true;
        bufferline = "multiple"; # Show buffer tabs when multiple files open

        # Cursor shapes per mode
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        # Text editing
        text-width = 120;
        auto-format = true; # Format on save (respects language config)
        completion-trigger-len = 1;
        completion-replace = true;

        # Wrapping
        soft-wrap = {
          enable = true;
          wrap-at-text-width = false; # Use viewport width
        };

        # Whitespace handling
        insert-final-newline = true; # Ensure files end with newline

        # File picker - hide build artifacts and Nix outputs
        file-picker = {
          hidden = false; # Show hidden files (we filter specific ones below)
        };

        # Diagnostics
        inline-diagnostics = {
          cursor-line = "hint"; # Show all diagnostics on current line
          other-lines = "error"; # Only show errors on other lines
        };

        # LSP
        lsp = {
          display-inlay-hints = true;
          display-signature-help-docs = true;
          auto-signature-help = true;
        };

        # Statusline with more info
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          center = [ "position-percentage" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
          ];
        };

        # Indent guides for structured files
        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 0;
        };
      };
    };
  };
}

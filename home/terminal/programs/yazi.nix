{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: {
  # general file info
  home.packages = [
    pkgs.exiftool
    packages.allmytoes
  ];

  # allmytoes.yazi plugin for thumbnail preview using freedesktop cache
  # Shares thumbnails with Dolphin/Nautilus via ~/.cache/thumbnails/
  home.file.".config/yazi/plugins/allmytoes.yazi/main.lua".source = "${packages.yazi-allmytoes}/main.lua";

  # Initialize allmytoes plugin
  home.file.".config/yazi/init.lua".text = ''
    -- Configure allmytoes thumbnail sizes
    -- Generate all sizes for compatibility with other applications
    require("allmytoes"):setup {
      sizes = {"n", "l", "x", "xx"}
    }
  '';

  # yazi file manager
  programs.yazi = {
    enable = true;

    package = inputs.yazi.packages.${pkgs.system}.default;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    settings = {
      manager = {
        ratio = [1 2 5];
        sort_by = "natural";
        linemod = "size_and_mtime";
      };
      preview = {
        max_width = 1024;
        max_height = 768;
        image_filter = "lanczos3";
        cache_dir = "${config.xdg.cacheHome}/yazi";
      };
      plugin = {
        prepend_previewers = [
          # Use allmytoes for images (shares thumbnails with Dolphin/Nautilus)
          { mime = "image/*"; run = "allmytoes"; }
        ];
        prepend_preloaders = [
          # Preload thumbnails for faster preview
          { mime = "image/*"; run = "allmytoes"; }
        ];
      };
      tasks = {
        image_alloc = 1073741824;  # 1GB allocation for large RAW files (42MP)
      };
    };
  };
}

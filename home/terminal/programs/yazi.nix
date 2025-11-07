{
  config,
  pkgs,
  inputs,
  packages,
  yaziPlugins,
  ...
}:
{
  # General file info tools
  home.packages = [
    pkgs.exiftool
    packages.allmytoes
  ];

  # yazi file manager
  programs.yazi = {
    enable = true;

    package = inputs.yazi.packages.${pkgs.system}.default;

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;

    # Advanced plugin configuration with auto-generated setup
    pluginConfig = with yaziPlugins; [
      glow
      hexyl
      {
        plugin = allmytoes;

        # Configure allmytoes thumbnail sizes
        # Generate all sizes for compatibility with other applications
        # Shares thumbnails with Dolphin/Nautilus via ~/.cache/thumbnails/
        setup = ''
          require("allmytoes"):setup {
            sizes = {"n", "l", "x", "xx"}
          }
        '';

        # Configure allmytoes to handle all image formats
        # Includes built-in support + custom providers (e.g., Sony ARW from file-manager.nix)
        previewers = [ "image/*" ];
        preloaders = [ "image/*" ];
      }
    ];

    settings = {
      manager = {
        ratio = [
          1
          2
          5
        ];
        sort_by = "natural";
        linemod = "size_and_mtime";
      };
      preview = {
        max_width = 1024;
        max_height = 768;
        image_filter = "lanczos3";
        cache_dir = "${config.xdg.cacheHome}/yazi";
      };
      tasks = {
        image_alloc = 1073741824; # 1GB allocation for large RAW files (42MP)
      };
    };
  };
}

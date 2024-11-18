{
  config,
  pkgs,
  inputs,
  ...
}: {
  # general file info
  home.packages = [pkgs.exiftool];

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
        cache_dir = config.xdg.cacheHome;
      };
    };
  };
}

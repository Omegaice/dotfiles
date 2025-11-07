{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nodejs
  ];

  home.sessionVariables = {
    npm_config_prefix = "${config.xdg.dataHome}/npm";
    npm_config_cache = "${config.xdg.cacheHome}/npm";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/npm/bin"
  ];

  # Create .npmrc file
  home.file.".npmrc".text = ''
    prefix=${config.xdg.dataHome}/npm
    cache=${config.xdg.cacheHome}/npm
  '';
}

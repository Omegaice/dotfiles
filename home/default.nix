{
  lib,
  config,
  ...
}: {
  home = {
    username = lib.mkDefault "jsweet";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.05";
    extraOutputsToInstall = ["doc" "devdoc"];

    enableNixpkgsReleaseCheck = false;
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}

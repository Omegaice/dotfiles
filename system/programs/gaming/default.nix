{...}: {
  imports = [
    ./steam.nix
    ./umu.nix
  ];

  programs.gamemode = {
    enable = true;
    settings = {
      general.inhibit_screensaver = 0;
    };
  };
}

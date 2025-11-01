{pkgs, ...}: {
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

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) winetricks heroic;
    inherit (pkgs.wineWowPackages) stable;
  };
}

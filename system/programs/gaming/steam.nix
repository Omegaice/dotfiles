{pkgs, ...}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

    # Firewall Settings
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    package = pkgs.steam.override {
      extraPkgs = (pkgs: with pkgs; [
        gamemode
      ]);
    };
  };
}

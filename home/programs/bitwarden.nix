{ pkgs, ... }:
{
  programs.bitwarden-cli = {
    enable = false;
    baseServer = "https://vault.james-sweet.com";
  };

  home.packages = with pkgs; [
    bitwarden-desktop
  ];
}

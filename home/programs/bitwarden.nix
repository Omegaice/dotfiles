{pkgs, ...}: {
  programs.bitwarden-cli = {
    enable = true;
    baseServer = "https://vault.james-sweet.com";
  };

  home.packages = with pkgs; [
    bitwarden
  ];
}

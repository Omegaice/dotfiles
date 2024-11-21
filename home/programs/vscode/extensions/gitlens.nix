{pkgs, ...}: {
  programs.vscode = {
    userSettings = {
      "gitlens.cloudPatches.enabled" = false;
      "gitlens.codeLens.enabled" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.plusFeatures.enabled" = false;
      "gitlens.rebaseEditor.ordering" = "asc";
      "gitlens.showWhatsNewAfterUpgrades" = false;
      "gitlens.telemetry.enabled" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
    ];
  };
}

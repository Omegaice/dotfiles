{ pkgs, ... }:
{
  programs.vscode = {
    userSettings = {
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.iconTheme" = "catppuccin-frappe";
      "catppuccin.boldKeywords" = false;
      "catppuccin.workbenchMode" = "flat";
      "catppuccin-icons.hidesExplorerArrows" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
  };
}

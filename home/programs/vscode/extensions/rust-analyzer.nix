{pkgs, ...}: {
  programs.vscode = {
    userSettings = {
      "rust-analyzer.testExplorer" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };
}

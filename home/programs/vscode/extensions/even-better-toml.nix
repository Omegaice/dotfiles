{pkgs, ...}: {
  programs.vscode = {
    userSettings = {
      "evenBetterToml.semanticTokens" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      tamasfe.even-better-toml
    ];
  };
}

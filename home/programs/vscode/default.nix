{pkgs, ...}: {
  imports = [
    ./extensions
  ];

  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.fontFamily" = "JetBrainsMono NF";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "extensions.ignoreRecommendations" = true;
      "git.allowForcePush" = true;
      "git.autofetch" = "all";
      "git.confirmSync" = false;
      "git.enableSmartCommit" = false;
      "git.fetchOnPull" = true;
      "git.mergeEditor" = true;
      "git.openRepositoryInParentFolders" = "never";
      "git.pruneOnFetch" = true;
      "git.pullBeforeCheckout" = true;
      "git.suggestSmartCommit" = false;
      "python.analysis.diagnosticMode" = "workspace";
      "python.analysis.typeCheckingMode" = "basic";
      "python.testing.pytestEnable" = true;
      "redhat.telemetry.enabled" = false;
      "rust-analyzer.testExplorer" = true;
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.iconTheme" = "catppuccin-frappe";
      "workbench.startupEditor" = "none";
      "files.autoSave" = "afterDelay";
      "editor.linkedEditing" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "editor.rulers" = [80 120];
      "editor.wordWrapColumn" = 120;
      "window.titleBarStyle" = "custom";
      "terminal.integrated.enablePersistentSessions" = false;
      "terminal.integrated.fontFamily" = "JetBrainsMono NFM";
      "catppuccin.boldKeywords" = false;
      "catppuccin.workbenchMode" = "flat";
      "catppuccin-icons.hidesExplorerArrows" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      # Styling
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      # Remote
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-containers
      # Nix
      mkhl.direnv
      jnoortheen.nix-ide
      # XML
      redhat.vscode-xml
      # YAML
      redhat.vscode-yaml
      # Python
      charliermarsh.ruff
      # C++
      twxs.cmake
      ms-vscode.cmake-tools
      # Rust
      rust-lang.rust-analyzer
    ];
  };
}

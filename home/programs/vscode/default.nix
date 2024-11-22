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
      "workbench.startupEditor" = "none";
      "files.autoSave" = "afterDelay";
      "editor.linkedEditing" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "editor.rulers" = [80 120];
      "editor.wordWrapColumn" = 120;
      "terminal.integrated.enablePersistentSessions" = false;
      "terminal.integrated.fontFamily" = "JetBrainsMono NFM";
    };
    extensions = with pkgs.vscode-extensions; [
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
    ];
  };
}

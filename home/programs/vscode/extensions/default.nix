{
  imports = [
    # Git
    ./gitlens.nix
    # # Styling
    ./catppuccin.nix
    #   # Remote
    #   ms-vscode-remote.remote-ssh
    #   ms-vscode-remote.remote-ssh-edit
    #   ms-vscode-remote.remote-containers
    #   # Nix
    #   mkhl.direnv
    #   jnoortheen.nix-ide
    #   # XML
    #   redhat.vscode-xml
    #   # YAML
    #   redhat.vscode-yaml
    #   # Python
    #   charliermarsh.ruff
    #   # C++
    #   twxs.cmake
    #   ms-vscode.cmake-tools
    #   # Rust
    ./rust-analyzer.nix
    ./even-better-toml.nix
  ];
}

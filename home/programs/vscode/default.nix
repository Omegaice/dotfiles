{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Git
      eamodio.gitlens
      # Nix
      mkhl.direnv
      jnoortheen.nix-ide
      # Rust
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
    ];
  };
}

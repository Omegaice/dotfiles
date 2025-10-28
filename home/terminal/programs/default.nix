{...}: {
  # Core terminal programs - modern CLI toolkit
  # Used across all hosts (laptop, WSL, servers)
  imports = [
    ./bat.nix       # Better cat with syntax highlighting
    ./btop.nix      # System monitor
    ./claude-code.nix # AI-powered coding assistant
    ./duf.nix       # Better df
    ./eza.nix       # Better ls
    ./git.nix       # Version control
    ./jq.nix        # JSON processor
    ./nix.nix       # Nix configuration
    ./rg.nix        # Better grep
    ./xdg.nix       # XDG base directories
    ./zellij.nix    # Terminal multiplexer
  ];
}

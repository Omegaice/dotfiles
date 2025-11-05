{pkgs, ...}: {
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;

    settings = {
      # System-wide permission configuration
      # These deny rules protect sensitive credentials across ALL projects
      # Only absolute paths (~/...) - no project-relative patterns
      # Project-specific patterns (.env, secrets/) go in .claude/settings.local.json
      permissions = {
        deny = [
          # SSH and GPG keys
          "Read(~/.ssh/**)"
          "Read(~/.gnupg/**)"

          # Claude Code's own credentials
          "Read(~/.claude/.credentials.json)"

          # Shell histories (contain typed secrets, passwords, tokens)
          "Read(~/.bash_history)"
          "Read(~/.zsh_history)"
          "Read(~/.python_history)"
          "Read(~/.node_repl_history)"
          "Read(~/.mysql_history)"
          "Read(~/.psql_history)"
          "Read(~/.sqlite_history)"
          "Read(~/.rediscli_history)"

          # Git credentials
          "Read(~/.config/git/credentials)"
          "Read(~/.git-credentials)"
          "Read(~/.gitconfig.local)"

          # Cloud provider credentials
          "Read(~/.aws/**)"
          "Read(~/.config/gcloud/**)"
          "Read(~/.azure/**)"

          # GitHub CLI
          "Read(~/.config/gh/**)"

          # Docker and Kubernetes
          "Read(~/.docker/**)"
          "Read(~/.kube/**)"

          # Password managers and keyrings
          "Read(~/.password-store/**)"
          "Read(~/.config/Bitwarden/**)"
          "Read(~/.config/1Password/**)"
          "Read(~/.local/share/keyrings/**)"

          # Browser profiles (session cookies, saved passwords)
          "Read(~/.mozilla/**)"
          "Read(~/.config/google-chrome/**)"
          "Read(~/.config/chromium/**)"
          "Read(~/.config/BraveSoftware/**)"

          # Database credential files
          "Read(~/.pgpass)"
          "Read(~/.my.cnf)"
          "Read(~/.mongorc.js)"

          # Language package manager credentials
          "Read(~/.npmrc)"
          "Read(~/.pypirc)"
          "Read(~/.cargo/credentials)"
          "Read(~/.cargo/credentials.toml)"
          "Read(~/.gem/credentials)"
          "Read(~/.m2/settings.xml)"
          "Read(~/.nuget/NuGet.Config)"
          "Read(~/.netrc)"

          # Subversion credentials
          "Read(~/.subversion/auth/**)"
        ];
      };

      # Sandbox configuration
      # Provides OS-level isolation for bash commands
      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
      };
    };
  };

  # Required for Claude Code sandbox mode (/sandbox command)
  home.packages = with pkgs; [
    socat
    bubblewrap
  ];
}

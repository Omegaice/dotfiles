{pkgs, ...}: {
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
  };

  # Required for Claude Code sandbox mode (/sandbox command)
  home.packages = with pkgs; [
    socat
    bubblewrap
  ];
}

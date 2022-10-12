{
  config,
  pkgs,
  ...
}: {
  targets.genericLinux.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    alejandra
    btop
    broot
    chezmoi
    csview
    dasel
    dua
    delta
    fd
    git-cliff # Generate changelog file from git commits
    hck # Replacement for cut with some improvements
    hyperfine # CLI to benchmark programs
    httpie
    iperf3
    just # Command runner
    k6
    kondo
    kubectl
    lefthook
    manix
    mmv
    ncdu
    ouch # (De)compression tool for multiple formats
    pandoc
    procs
    ripgrep
    salt-lint
    shellcheck
    statix
    taskwarrior
    taskwarrior-tui
    terraform
    tokei # Source code line counter
    yt-dlp

    # Language Servers
    nodePackages.bash-language-server # Bash
    rnix-lsp # Nix 
    taplo-lsp # TOML
  ];

  # Setup Paths
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs = {
    # Tools
    taskwarrior.enable = true;
    git = {
      enable = true;
      lfs.enable = true;

      difftastic = {
        enable = true;
        background = "dark";
      };

      userName = "James Sweet";
      userEmail = "james.sweet@protonmail.com";

      extraConfig = {
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
      };
    };
    gh.enable = true;
    gh.enableGitCredentialHelper = true;

    # Shell
    starship.enable = true; # Prompt
    zoxide.enable = true; # Directory changer that attempts to guess based on history
    fzf.enable = true;

    bat.enable = true;
    exa.enable = true;
    jq.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index.enable = true;

    # Editors
    helix = {
      enable = true;
      languages = [
        {
          name = "nix";
          formatter = {
            command = "alejandra";
          };
        }
      ];
    };

    zsh = {
      enable = true;
      autocd = true;
      shellAliases = {
        update-home = "$HOME/.config/nixpkgs/update.sh";
        ls = "exa";
      };
      sessionVariables = { 
        EDITOR = "${pkgs.helix}/bin/hx"; 
      };
    };

    nushell = {
      enable = true;
    };
  };
  
  services = {
    pueue.enable = true;
  };
}

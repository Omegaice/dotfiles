{
  withSystem,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations."jsweet" = withSystem "x86_64-linux" (ctx @ {
      pkgs,
      inputs',
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit (ctx) pkgs;

        modules = [
          ./package-diff
          {
            programs.home-manager.enable = true;
            home = {
              stateVersion = "23.05";
              username = "jsweet";
              homeDirectory = "/home/jsweet";
            };
          }
          (
            {pkgs, ...}: {
              targets.genericLinux.enable = true;

              # Packages that should be installed to the user profile.
              home.packages = with pkgs; [
                inputs'.alejandra.packages.default # Nix Formatter
                btop
                broot
                csview
                dasel
                dua
                delta
                fd
                git-cliff # Generate changelog file from git commits
                hatch # Python package manager
                hck # Replacement for cut with some improvements
                hyperfine # CLI to benchmark programs
                httpie
                iperf3
                just # Command runner
                k6 # http load testing
                kondo
                kubectl # Kubernetes
                kubectx
                helm
                kubevirt # CLI tool for KubeVirt
                lefthook
                mmv
                ncdu
                nix-output-monitor # Statistics of what is happening during nix build
                nurl # Generate fetcher for nix from URL
                ouch # (De)compression tool for multiple formats
                pandoc
                procs
                ripgrep
                inputs'.omegaice.packages.salt-lint
                shellcheck
                statix # Nix Linter
                taskwarrior-tui
                terraform
                tokei # Source code line counter
                inputs'.omegaice.packages.vermin # Python - Minimum version required by package
                yt-dlp # Video Downloader

                # Language Servers
                nodePackages.bash-language-server # Bash
                nil # Nix
                taplo-lsp # TOML
              ];

              manual.manpages.enable = false;

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
                starship = {
                  enable = true; # Prompt
                  settings = {
                    container = {
                      disabled = true;
                    };
                  };
                };
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
                  defaultKeymap = "emacs";
                  sessionVariables = {
                    EDITOR = "${pkgs.helix}/bin/hx";
                  };
                  initExtra = ''
                    bindkey  "^[[H"   beginning-of-line
                    bindkey  "^[[F"   end-of-line
                    bindkey  "^[[3~"  delete-char
                  '';
                };

                nushell = {
                  enable = true;
                };
              };

              services = {
                pueue.enable = true;
              };
            }
          )
        ];
      });
  };
}

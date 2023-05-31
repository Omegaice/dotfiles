{
  withSystem,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations."jsweet" = withSystem "x86_64-linux" (ctx @ {
      pkgs,
      inputs',
      final,
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
                broot
                csview
                #dasel
                #dua
                # delta
                fd
                hck # Replacement for cut with some improvements
                hyperfine # CLI to benchmark programs
                httpie
                # iperf3
                just # Command runner
                # k6 # http load testing
                kondo
                # kubectl # Kubernetes
                # kubectx
                # helm
                # kubevirt # CLI tool for KubeVirt
                # lefthook
                mmv
                ncdu
                nix-output-monitor # Statistics of what is happening during nix build
                nurl # Generate fetcher for nix from URL
                # ouch # (De)compression tool for multiple formats
                # pandoc
                # final.pdm # Python dependency manager
                procs
                ripgrep
                #inputs'.omegaice.packages.salt-lint
                # shellcheck
                # statix # Nix Linter
                # taskwarrior-tui
                # terraform
                # tokei # Source code line counter
                #inputs'.omegaice.packages.vermin # Python - Minimum version required by package
                #yt-dlp # Video Downloader

                # Language Servers
                # nodePackages.bash-language-server # Bash
                nil # Nix
                # taplo-lsp # TOML
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
                    core.fileMode = false;
                    core.untrackedcache = true;
                    init.defaultBranch = "master";
                    push.autoSetupRemote = true;
                    safe.directory = [
                      "*"
                    ];
                    fetch.prune = true;
                    fetch.pruneTags = true;
                  };
                };

                gh = {
                  enable = true;
                  extensions = [pkgs.gh-actions-cache];
                };

                git-cliff = {
                  # Generate changelog file from git commits
                  enable = true;
                };

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

                bat = {
                  enable = true;
                  config = {
                    pager = "never";
                    theme = "OneHalfDark";
                    style = "full";
                  };
                };

                exa = {
                  enable = true;
                  icons = true;
                  git = true;
                };

                jq.enable = true;

                direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                };

                nix-index.enable = true;

                btop = {
                  # Top Replacement
                  enable = true;
                };

                # Editors
                helix = {
                  enable = true;
                  settings = {
                    editor = {
                      text-width = 120;
                      soft-wrap.enable = true;
                      lsp.display-inlay-hints = true;
                    };
                  };
                  languages = {
                    "nix" = {
                      formatter = {
                        command = "alejandra";
                      };
                    };
                  };
                };

                zsh = {
                  enable = true;
                  autocd = true;
                  shellAliases = {
                    update-home = "$HOME/.config/nixpkgs/update.sh";
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
              };
            }
          )
        ];
      });
  };
}

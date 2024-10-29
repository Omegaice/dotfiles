{
  withSystem,
  inputs,
  lib,
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
            let
              worktree-clone = pkgs.writeShellApplication {
                name = "worktree-clone";
                runtimeInputs = [pkgs.git];
                text = ''
                  url=$1
                  basename=''${url##*/}
                  name=''${2:-''${basename%.*}}

                  mkdir "$name"
                  cd "$name"

                  # Moves all the administrative git files (a.k.a $GIT_DIR) under .bare directory.
                  git clone --bare "$url" .bare
                  echo "gitdir: ./.bare" > .git

                  # Explicitly sets the remote origin fetch so we can fetch remote branches
                  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

                  # Gets all branches from origin
                  git fetch origin

                  # Create a main branch folder if one doesn't exist
                  main_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
                  if [[ -n "$main_branch" && ! -d "$main_branch" ]]; then
                      git worktree add "$main_branch"
                  fi
                '';
              };
            in
              {pkgs, ...}: {
                targets.genericLinux.enable = true;

                # Packages that should be installed to the user profile.
                home.packages = with pkgs; [
                  pkgs.alejandra # Nix Formatter
                  # broot
                  csview
                  #dasel
                  #dua
                  # delta
                  devenv
                  fd
                  glow
                  hck # Replacement for cut with some improvements
                  hyperfine # CLI to benchmark programs
                  httpie
                  hexyl
                  # iperf3
                  just # Command runner
                  # k6 # http load testing
                  # kondo
                  # kubectl # Kubernetes
                  # kubectx
                  # helm
                  # kubevirt # CLI tool for KubeVirt
                  # lefthook
                  # mmv
                  ncdu
                  nix-output-monitor # Statistics of what is happening during nix build
                  nurl # Generate fetcher for nix from URL
                  # ouch # (De)compression tool for multiple formats
                  # pandoc
                  #final.pdm # Python dependency manager
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
                  # taskwarrior.enable = true;
                  git = {
                    enable = true;
                    lfs.enable = true;

                    difftastic = {
                      enable = true;
                      background = "dark";
                    };

                    userName = "Omegaice";
                    userEmail = "950526+Omegaice@users.noreply.github.com";

                    aliases = {
                      clone-worktree = "!bash ${lib.getExe worktree-clone}";
                    };

                    extraConfig = {
                      branch.sort = "-committerdate";
                      core = {
                        fileMode = false;
                        longpaths = true;
                        untrackedcache = true;
                      };
                      diff = {
                        algorithm = "histogram";
                        submodule = "log";
                      };
                      fetch = {
                        prune = true;
                        pruneTags = true;
                      };
                      init.defaultBranch = "master";
                      log = {
                        abbrevCommit = true;
                        date = "iso";
                      };
                      merge.conflictStyle = "zdiff3";
                      push = {
                        autoSetupRemote = true;
                        followtags = true;
                      };
                      rebase = {
                        autosquash = true;
                        updateRefs = true;
                      };
                      safe.directory = [
                        "*"
                      ];
                      status.submoduleSummary = true;
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

                  eza = {
                    enable = true;
                    icons = "auto";
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

                  zellij = {
                    enable = true;
                    settings = {
                      pane_frames = false;
                      default_layout = "compact";
                      ui = {
                        pane_frames = {
                          hide_session_name = true;
                        };
                      };
                    };
                  };

                  yazi = {
                    enable = true;
                    plugins = {
                      glow = final.yazi-glow;
                      hexyl = final.yazi-hexyl;
                    };
                    settings = {
                      plugin = {
                        prepend_previewers = [
                          {
                            name = "*.md";
                            run = "glow";
                          }
                        ];
                        append_previewers = [
                          {
                            name = "*";
                            run = "hexyl";
                          }
                        ];
                      };
                    };
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
                    defaultKeymap = "emacs";
                    sessionVariables = {
                      EDITOR = "${pkgs.helix}/bin/hx";
                    };
                    initExtra = ''
                      bindkey  "^[[H"   beginning-of-line
                      bindkey  "^[[F"   end-of-line
                      bindkey  "^[[3~"  delete-char
                      alias cat="bat"
                    '';
                  };
                };
              }
          )
        ];
      });
  };
}

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

        extraSpecialArgs = {inherit inputs;};

        modules = [
          ./package-diff
          ../home
          ../home/editor/helix
          ../home/terminal/programs/bat.nix
          ../home/terminal/programs/btop.nix
          ../home/terminal/programs/git.nix
          ../home/terminal/programs/nix.nix
          ../home/terminal/programs/xdg.nix
          ../home/terminal/programs/yazi.nix
          ../home/terminal/programs/zellij.nix
          ../home/terminal/shell/atuin.nix
          ../home/terminal/shell/starship.nix
          ../home/terminal/shell/zoxide.nix
          ../home/terminal/shell/zsh.nix
          (
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

              programs = {
                # Shell
                fzf.enable = true;

                eza = {
                  enable = true;
                  icons = "auto";
                  git = true;
                };

                jq.enable = true;

                nix-index.enable = true;
              };
            }
          )
        ];
      });
  };
}

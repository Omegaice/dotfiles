{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    helix,
    home-manager,
    system-manager,
    alejandra,
    yazi,
    pre-commit-hooks,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./host
        ./home-manager
        ./packages
        flake-parts.flakeModules.easyOverlay
      ];
      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        pkgs,
        self',
        inputs',
        system,
        ...
      }: {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
            };
          };
        };

        apps = {
          install = let
            installer = pkgs.writeShellApplication {
              name = "installer";

              runtimeInputs = builtins.attrValues {
                inherit
                  (pkgs)
                  nix-output-monitor
                  nvd
                  busybox
                  ;
              };

              text = ''
                set -x

                # Build new environment
                PACKAGE="path:''${HOME}/.config/nixpkgs#homeConfigurations.''${USER}.activationPackage"
                nom build --no-link "$PACKAGE"

                # Remove any old environments
                OLD_PROFILE="''${HOME}/.local/state/nix/profiles/profile/home-manager"
                if [[ -d "$OLD_PROFILE" ]]; then
                  nvd diff "$$OLD_PROFILE" "$(nix path-info "$PACKAGE")"
                  nix profile remove "$(nix profile list | grep home-manager-path | awk '{print $1};')"
                fi

                # Activate new environment
                "$(nix path-info "$PACKAGE")"/activate
              '';
            };
          in {
            type = "app";
            program = "${installer}/bin/installer";
          };
        };

        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          inherit (self'.checks.pre-commit-check) shellHook;

          buildInputs =
            builtins.attrValues {
            };
        };
      };
      flake = {
        templates.rust = {
          path = ./templates/rust;
          description = "";
        };
      };
    };
}

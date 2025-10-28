{
  description = "Home Manager configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    anyrun.url = "github:fufexan/anyrun/launch-prefix";

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:Omegaice/nixos-hardware/master";

    yazi.url = "github:sxyazi/yazi";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprwm
    hyprland = {
      url = "github:hyprwm/hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs = {
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs-unstable,
    helix,
    deploy-rs,
    home-manager,
    hyprland,
    hyprpolkitagent,
    nixos-hardware,
    system-manager,
    alejandra,
    yazi,
    pre-commit-hooks,
    umu,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      imports = [
        ./host
        ./packages
        ./flake-modules/deploy-rs.nix
        flake-parts.flakeModules.easyOverlay
      ];
      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        lib,
        pkgs,
        config,
        self',
        inputs',
        system,
        ...
      }: {
        # checks = {
        #   pre-commit-check = pre-commit-hooks.lib.${system}.run {
        #     src = ./.;
        #     hooks = {
        #       alejandra.enable = true;
        #       statix.enable = true;
        #     };
        #   };
        # };

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
          # inherit (self'.checks.pre-commit-check) shellHook;

          buildInputs = builtins.attrValues {
            inherit (inputs'.deploy-rs.packages) deploy-rs;
          };
        };
      };
    };
}

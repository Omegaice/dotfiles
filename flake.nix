{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    omegaice = {
      url = "github:omegaice/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    omegaice,
    ...
  }: let
    username = "omegaice";
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.${system}
        alejandra.overlays.default
        omegaice.overlays.default
        (final: prev: {
          python3 = prev.python3.override {
            packageOverrides = self: super: {
              hatchling = super.hatchling.overridePythonAttrs (old: rec {
                version = "1.11.1";
                src = super.fetchPypi {
                  inherit (old) pname;
                  inherit version;
                  sha256 = "sha256-n4Q2H3DPOnq5VDsMPsxkIR7SuopganHrakc8HJsI4dA=";
                };
              });
            };
          };

          hatch = prev.hatch.overridePythonAttrs (old: rec {
            version = "1.6.3";

            src = prev.fetchFromGitHub {
              inherit version;
              owner = "pypa";
              repo = "hatch";
              rev = "hatch-v${version}";
              sha256 = "sha256-3nPh6F+TmLoogz9FgaZMub7hPJIzANCY4oWk9Mq22Pc=";
            };

            propagatedBuildInputs =
              old.propagatedBuildInputs
              ++ [
                prev.python3.pkgs.hyperlink
              ];

            disabledTestPaths = [
              "tests/cli/publish/test_publish.py"
            ];
          });
        })
      ];
    };
  in rec
  {
    overlays.${system} = final: prev: {};

    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home.nix
        {
          programs.home-manager.enable = true;
          home = {
            stateVersion = "22.11";
            username = "${username}";
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };
  };
}

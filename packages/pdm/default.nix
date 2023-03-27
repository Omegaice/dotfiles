{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
}: let
  python = python3.override {
    # override resolvelib due to
    # 1. pdm requiring a later version of resolvelib
    # 2. Ansible being packaged as a library
    # 3. Ansible being unable to upgrade to a later version of resolvelib
    # see here for more details: https://github.com/NixOS/nixpkgs/pull/155380/files#r786255738
    packageOverrides = self: super: {
      resolvelib = super.resolvelib.overridePythonAttrs (attrs: rec {
        version = "0.9.0";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = "/refs/tags/${version}";
          hash = "sha256-xzu8sMNMihJ80vezMdGkOT5Etx08qy3T/TkEn5EAY48=";
        };
      });
    };
    self = python;
  };
in
  with python.pkgs;
    buildPythonApplication rec {
      pname = "pdm";
      version = "2.4.9";
      format = "pyproject";
      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-28b/sZXzmrJLS8tQf+mXiaYaMhWdi/In8xF7lPMn8vI=";
      };

      postUnpack = ''
        substituteInPlace $sourceRoot/src/pdm/cli/actions.py \
          $sourceRoot/src/pdm/cli/commands/completion.py\
          $sourceRoot/src/pdm/cli/commands/venv/backends.py\
          $sourceRoot/src/pdm/models/environment.py\
          $sourceRoot/src/pdm/project/core.py \
          $sourceRoot/tests/cli/test_venv.py \
          --replace "sys.executable" "\"${python.withPackages (ps: [ps.virtualenv])}/bin/python\""
      '';

      nativeBuildInputs = [
        pdm-pep517
        pythonRelaxDepsHook
      ];

      pythonRelaxDeps = ["installer"];

      propagatedBuildInputs =
        [
          blinker
          cachecontrol
          certifi
          findpython
          installer
          packaging
          platformdirs
          pyproject-hooks
          python-dotenv
          requests-toolbelt
          resolvelib
          rich
          shellingham
          tomlkit
          unearth
          virtualenv
        ]
        ++ cachecontrol.optional-dependencies.filecache
        ++ lib.optionals (pythonOlder "3.11") [
          tomli
        ]
        ++ lib.optionals (pythonOlder "3.10") [
          importlib-metadata
        ];

      nativeCheckInputs = [
        pytestCheckHook
        pytest-mock
        pytest-rerunfailures
        pytest-xdist
      ];

      pytestFlagsArray = [
        "-m 'not network'"
      ];

      preCheck = ''
        export HOME=$TMPDIR
      '';

      disabledTests = [
        # fails to locate setuptools (maybe upstream bug)
        "test_convert_setup_py_project"
        # pythonfinder isn't aware of nix's python infrastructure
        "test_use_wrapper_python"
        "test_use_invalid_wrapper_python"
      ];

      meta = with lib; {
        homepage = "https://pdm.fming.dev";
        changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
        description = "A modern Python package manager with PEP 582 support";
        license = licenses.mit;
        maintainers = with maintainers; [cpcloud];
      };
    }

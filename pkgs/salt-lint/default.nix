{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "salt-lint";
  version = "0.8.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "wLIU3PAhvXLxn0fuZ1LP7xH5zOm1xN8HEfkGbMTpNKE=";
  };

  propagatedBuildInputs = with python3.pkgs; [ pyyaml pathspec ];

  meta = with lib; {
    homepage = "https://github.com/warpnet/salt-lint";
    changelog = "https://github.com/warpnet/salt-lint/blob/v${version}/CHANGELOG.md";
    description = "A command-line utility that checks for best practices in SaltStack.";
    license = licenses.mit;
  };
}

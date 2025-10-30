{
  lib,
  stdenv,
  fetchFromGitHub,
  allmytoes,
}:
stdenv.mkDerivation rec {
  pname = "allmytoes-yazi";
  version = "unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "Sonico98";
    repo = "allmytoes.yazi";
    rev = "master";
    hash = "sha256-FD2kzmavY+xSQEnuNnDmGwI92mA1K6LMX/LXFRdewI0=";
  };

  propagatedBuildInputs = [
    allmytoes
  ];

  # Fix for yazi v25.5.28+ API changes:
  # - preview_widgets() -> preview_widget() (singular)
  # - Handle errors from ya.image_show()
  # - Strip file:// prefix from URLs before passing to allmytoes
  installPhase = ''
    mkdir $out
    cp ${./yazi-allmytoes-main.lua} $out/main.lua
  '';

  meta = {
    description = "AllMyToes thumbnail preview plugin for yazi";
    homepage = "https://github.com/Sonico98/allmytoes.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "allmytoes-yazi";
    platforms = lib.platforms.all;
  };
}

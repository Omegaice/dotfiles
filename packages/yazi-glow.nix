{
  lib,
  stdenv,
  fetchFromGitHub,
  glow,
}:
stdenv.mkDerivation rec {
  pname = "glow-yazi";
  version = "unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "d8b36ff0113e73a400891726dc2eca8b3c049dea";
    hash = "sha256-fKJ5ld5xc6HsM/h5j73GABB5i3nmcwWCs+QSdDPA9cU=";
  };

  propagatedBuildInputs = [
    glow
  ];

  installPhase = ''
    mkdir $out
    cp $src/init.lua $out/
  '';

  meta = {
    description = "Glow preview plugin for yazi";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "glow-yazi";
    platforms = lib.platforms.all;
  };
}

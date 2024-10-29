{
  lib,
  stdenv,
  fetchFromGitHub,
  hexyl,
}:
stdenv.mkDerivation rec {
  pname = "hexyl-yazi";
  version = "unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "hexyl.yazi";
    rev = "ccc0a4a959bea14dbe8f2b243793aacd697e34e2";
    hash = "sha256-9rPJcgMYtSY5lYnFQp3bAhaOBdNUkBaN1uMrjen6Z8g=";
  };

  propagatedBuildInputs = [
    hexyl
  ];

  installPhase = ''
    mkdir $out
    cp $src/init.lua $out/
  '';

  meta = {
    description = "An hexyl plugin for yazi";
    homepage = "https://github.com/Reledia/hexyl.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "hexyl-yazi";
    platforms = lib.platforms.all;
  };
}

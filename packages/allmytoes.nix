{
  lib,
  rustPlatform,
  fetchFromGitLab,
  imagemagick,
  exiftool,
}:
rustPlatform.buildRustPackage rec {
  pname = "allmytoes";
  version = "0.4.0-patched-v2";

  src = fetchFromGitLab {
    owner = "allmytoes";
    repo = "allmytoes";
    rev = "main";
    hash = "sha256-qk/Zz6BnOZOKsvSNvEI405QmRvMORQTtgmlQa64dx8M=";
  };

  # Patch to use xdg-mime GuessBuilder API for better MIME detection
  # Combines filename, metadata, and content analysis with proper prioritization
  # Fixes RAW files (ARW, CR2, NEF) being misdetected as generic image/tiff
  # by ensuring filename extensions are properly weighted in detection
  patches = [ ./allmytoes-prefer-filename-mime.patch ];

  cargoHash = "sha256-jtHNWeYNLhYkMo6B/7L8JZ0atloj2UYNaxzKUV/yZUw=";

  # Runtime dependencies for provider commands
  buildInputs = [
    imagemagick
    exiftool
  ];

  # Install provider configuration
  postInstall = ''
    mkdir -p $out/share/allmytoes
    cp -r conf/provider.yaml $out/share/allmytoes/
  '';

  meta = {
    description = "Provides thumbnails according to the freedesktop.org specification";
    homepage = "https://gitlab.com/allmytoes/allmytoes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [];
    mainProgram = "allmytoes";
    platforms = lib.platforms.linux;
  };
}

{
  pkgs,
  lib,
  packages,
  ...
}:
let
  # Sony ARW RAW image MIME type
  # ARW files are TIFF containers and most thumbnailers misdetect them as image/tiff
  sonyArwMimeXML = pkgs.writeText "sony-arw.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="image/x-sony-arw">
        <comment>Sony Alpha RAW image</comment>
        <glob pattern="*.arw" weight="60"/>
        <glob pattern="*.ARW" weight="60"/>
        <sub-class-of type="image/tiff"/>
        <magic priority="60">
          <match value="II" type="string" offset="0">
            <match value="0x002a" type="big16" offset="2">
              <match value="SONY" type="string" offset="8"/>
            </match>
          </match>
        </magic>
      </mime-type>
    </mime-info>
  '';
in
{
  home.packages = with pkgs; [
    # GTK file manager - simple, opinionated, GNOME-style
    nautilus

    # KDE file manager - dual-pane (F3), customizable, power-user features
    # Qt 6-based (KDE Plasma 6)
    kdePackages.dolphin
    kdePackages.kio # KDE file protocols
    kdePackages.kio-extras # Additional protocols: SMB, FTP, SSH, etc.
    kdePackages.ark # KDE archive manager (integrates with Dolphin)

    # RAW image support (Sony ARW, Canon CR2, Nikon NEF, etc.)
    # For file manager thumbnails and previews
    kdePackages.kimageformats # KDE image format plugins (RAW via libraw)
    kdePackages.kdegraphics-thumbnailers # KDE thumbnail generators (for Dolphin)
    libraw # Core RAW processing library (used by multiple tools)
    libheif # HEIF/HEIC support (newer cameras, iPhones)

    # Tools for allmytoes providers
    imagemagick # Universal image converter with RAW support via libraw
    exiftool # Read EXIF metadata, extract embedded JPEG previews from RAW
    ffmpegthumbnailer # Fast video thumbnail generator
    inkscape # SVG rendering

    # Archive support for Nautilus
    file-roller # GNOME archive manager
  ];

  # Register Sony ARW MIME type in XDG database
  xdg.dataFile."mime/packages/sony-arw.xml".source = sonyArwMimeXML;
  xdg.mime.enable = true;

  # AllMyToes thumbnail generator with Sony ARW provider
  programs.allmytoes = {
    enable = true;
    package = packages.allmytoes;

    # Sony ARW RAW image provider with optimized embedded preview extraction
    providers.sonyArw = {
      mimes = [ "image/x-sony-arw" ];
      commands = [
        # Fast path: Extract embedded JPEG preview (instant, 30-50x faster for 40MP files)
        ''
          ${pkgs.exiftool}/bin/exiftool -b -PreviewImage "%(file)s" 2>/dev/null | \
          ${pkgs.imagemagick}/bin/magick - -thumbnail %(size)sx%(size)s -strip -quality 90 "%(outfile)s" 2>/dev/null
        ''
        # Fallback: Full RAW conversion (slow but reliable)
        ''
          ${pkgs.imagemagick}/bin/magick "%(file)s" -thumbnail %(size)sx%(size)s -strip -quality 90 "%(outfile)s" 2>/dev/null
        ''
      ];
      revision = 1;
    };

    # Register as freedesktop thumbnailer (includes RAW types automatically)
    thumbnailer.enable = true;
  };
}

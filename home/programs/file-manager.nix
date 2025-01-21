{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
  ];

  # Setup Thumbnailers
  xdg.dataFile."thumbnailers/ffmpegthumbnailer.thumbnailer".source = "${pkgs.ffmpegthumbnailer}/share/thumbnailers/ffmpegthumbnailer.thumbnailer";
}

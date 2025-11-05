{
  lib,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      # Disable libcamera monitoring to reduce overhead
      "wireplumber.profiles".main."monitor.libcamera" = "disabled";

      # Enable high-quality Bluetooth audio codecs
      "bluetooth.conf" = {
        "monitor.bluez.properties" = {
          # Enable high-quality codecs for Bluetooth audio
          "bluez5.enable-sbc-xq" = true;  # SBC XQ (high quality SBC)
          "bluez5.enable-msbc" = true;    # mSBC (for headset calls)
          "bluez5.enable-hw-volume" = true; # Hardware volume control

          # Codec priorities (higher = preferred)
          # Opus: PipeWire-specific (only works between PipeWire devices)
          # LDAC: Sony's high-quality codec (up to 990 kbps)
          # aptX HD: Qualcomm's codec (576 kbps, low latency)
          # aptX: Standard Qualcomm codec (384 kbps)
          # AAC: Apple's codec (good quality)
          # SBC XQ: Enhanced SBC (better than standard SBC)
          "bluez5.codecs" = [
            "opus_05"  # Best quality (PipeWire-to-PipeWire only, not for commercial headphones)
            "ldac"     # Best quality for real hardware (Sony)
            "aptx_hd"  # High quality, low latency (Qualcomm)
            "aptx"     # Good quality (Qualcomm)
            "aac"      # Apple devices
            "sbc_xq"   # Enhanced SBC fallback
            "sbc"      # Universal fallback
          ];

          # LDAC encoding quality: auto, hq, sq, mq
          # hq = High Quality (990 kbps, best quality)
          # sq = Standard Quality (660 kbps, balanced)
          # mq = Mobile Quality (330 kbps, best range)
          "bluez5.default.rate" = 48000;
          "bluez5.default.channels" = 2;
        };
      };
    };
  };

  # Ensure Bluetooth audio codecs are available
  environment.systemPackages = with pkgs; [
    # These provide additional codec support
    ldacbt  # LDAC Bluetooth codec library
  ];
}

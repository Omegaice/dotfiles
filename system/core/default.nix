{ lib, ... }:
{
  # Should not be changed
  system.stateVersion = lib.mkDefault "25.04";

  # Localization Setup
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  # Time
  time.timeZone = lib.mkDefault "America/Indiana/Indianapolis";
}

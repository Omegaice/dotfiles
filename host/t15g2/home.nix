{
  inputs,
  pkgs,
  packages,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs packages;
    };

    users."omegaice".imports = [
      {
        home.username = "omegaice";
        home.packages = with pkgs; [
          nil
          playerctl # Media player control via MPRIS
          packages.nw-generate-launcher
        ];
        services.gnome-keyring.enable = true;
        services.hyprland-game-handler.enable = true;
      }
      ../../home
      ../../home/gtk.nix
      ../../home/editor/helix

      # Terminal emulators
      ../../home/terminal/emulators/ghostty.nix
      ../../home/terminal/emulators/kitty.nix

      # Terminal programs (core CLI tools)
      ../../home/terminal/programs/bat.nix
      ../../home/terminal/programs/btop.nix
      ../../home/terminal/programs/bun.nix
      ../../home/terminal/programs/claude-code.nix
      ../../home/terminal/programs/duf.nix
      ../../home/terminal/programs/eza.nix
      ../../home/terminal/programs/git.nix
      ../../home/terminal/programs/jq.nix
      ../../home/terminal/programs/nix.nix
      ../../home/terminal/programs/pulsemixer.nix
      ../../home/terminal/programs/rg.nix
      ../../home/terminal/programs/xdg.nix
      ../../home/terminal/programs/yazi.nix
      ../../home/terminal/programs/zellij.nix

      # Shell enhancements
      ../../home/terminal/shell/atuin.nix
      ../../home/terminal/shell/nix-index.nix
      ../../home/terminal/shell/starship.nix
      ../../home/terminal/shell/zoxide.nix
      ../../home/terminal/shell/zsh.nix

      # GUI Applications
      ../../home/programs/anyrun.nix
      ../../home/programs/audio.nix
      ../../home/programs/bitwarden.nix
      ../../home/programs/dex.nix
      ../../home/programs/file-manager.nix
      ../../home/programs/firefox
      ../../home/programs/mangohud.nix
      ../../home/programs/media
      ../../home/programs/slack.nix
      ../../home/programs/steam.nix
      ../../home/programs/vscode
      ../../home/programs/zoom.nix

      # Wayland/Hyprland
      ../../home/programs/wayland/hyprland/default.nix
      ../../home/programs/wayland/hyprland/settings.nix
      ../../home/programs/wayland/clipboard.nix
      ../../home/programs/wayland/dunst.nix
      ../../home/programs/wayland/hypridle.nix
      ../../home/programs/wayland/hyprlock.nix
      ../../home/programs/wayland/screenshot.nix
      ../../home/programs/wayland/swayosd.nix
      ../../home/programs/wayland/waybar.nix

      # Services
      ../../home/services/bluetooth.nix
    ];
  };
}

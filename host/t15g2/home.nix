{
  inputs,
  pkgs,
  ...
}: {
  home-manager = {
    extraSpecialArgs = {inherit inputs;};

    users."omegaice".imports = [
      {
        home.username = "omegaice";
        home.packages = with pkgs; [
          nil
          pavucontrol
        ];
        services.gnome-keyring.enable = true;
      }
      ../../home
      ../../home/gtk.nix
      ../../home/editor/helix

      # Terminal environment (core CLI tools, shell enhancements)
      ../../home/terminal
      ../../home/terminal/emulators/ghostty.nix
      ../../home/terminal/emulators/kitty.nix
      ../../home/terminal/programs/yazi.nix
      ../../home/terminal/shell/zsh.nix

      # GUI Applications
      ../../home/programs/anyrun.nix
      ../../home/programs/bitwarden.nix
      ../../home/programs/file-manager.nix
      ../../home/programs/firefox
      ../../home/programs/media
      ../../home/programs/slack.nix
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
      ../../home/services/ghostty.nix
    ];
  };
}

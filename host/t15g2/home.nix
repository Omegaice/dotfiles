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
      ../../home/programs/anyrun.nix
      ../../home/programs/bitwarden.nix
      ../../home/programs/file-manager.nix
      ../../home/programs/firefox
      ../../home/programs/media
      ../../home/programs/slack.nix
      ../../home/programs/vscode
      ../../home/programs/zoom.nix
      ../../home/programs/wayland/hyprland/default.nix
      ../../home/programs/wayland/hyprland/settings.nix
      ../../home/programs/wayland/clipboard.nix
      ../../home/programs/wayland/dunst.nix
      ../../home/programs/wayland/hyprlock.nix
      ../../home/programs/wayland/waybar.nix
      ../../home/services/bluetooth.nix
      ../../home/terminal/emulators/ghostty.nix
      ../../home/terminal/emulators/kitty.nix
      ../../home/terminal/programs/bat.nix
      ../../home/terminal/programs/btop.nix
      ../../home/terminal/programs/duf.nix
      ../../home/terminal/programs/eza.nix
      ../../home/terminal/programs/git.nix
      ../../home/terminal/programs/jq.nix
      ../../home/terminal/programs/nix.nix
      ../../home/terminal/programs/xdg.nix
      ../../home/terminal/programs/yazi.nix
      ../../home/terminal/programs/zellij.nix
      ../../home/terminal/programs/zoxide.nix
      ../../home/terminal/shell/atuin.nix
      ../../home/terminal/shell/nix-index.nix
      ../../home/terminal/shell/zsh.nix
      ../../home/terminal/shell/starship.nix
    ];
  };
}

{
  self,
  inputs,
  withSystem,
  ...
}: {
  deploy.nodes.t15g2 = {
    hostname = "10.42.1.224";
    fastConnection = true;
    interactiveSudo = true;
    profiles = {
      system = {
        sshUser = "root";
        path =
          inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.t15g2;
        user = "root";
      };
    };
  };

  flake.nixosConfigurations.t15g2 = withSystem "x86_64-linux" (ctx @ {
    config,
    inputs',
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      # Expose `packages`, `inputs` and `inputs'` as module arguments.
      # Use specialArgs permits use in `imports`.
      # Note: if you publish modules for reuse, do not rely on specialArgs, but
      # on the flake scope instead. See also https://flake.parts/define-module-in-separate-file.html
      specialArgs = {
        inherit inputs inputs';
        inherit (ctx.config) packages;
      };
      modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t15-intel-gen2
        ./hardware-configuration.nix
        ../../system/core
        ../../system/core/boot.nix
        ../../system/hardware/bluetooth.nix
        ../../system/hardware/fwupd.nix
        ../../system/nix
        ../../system/network
        ../../system/programs
        ../../system/programs/fonts.nix
        ../../system/programs/home-manager.nix
        ../../system/programs/hyprland.nix
        ../../system/programs/qt.nix
        # ../../system/programs/xdg.nix
        ../../system/programs/zfs.nix
        ../../system/programs/gaming
        ../../system/services/greetd.nix
        ../../system/services/pipewire.nix
        ../../system/services/power.nix
        ../../system/services/ssh.nix
        ({
          config,
          lib,
          packages,
          pkgs,
          ...
        }: {
          networking.hostName = "t15g2"; # Define your hostname.

          boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

          users.users.omegaice = {
            isNormalUser = true;
            home = "/home/omegaice";
            extraGroups = ["wheel" "networkmanager" "input"];
            shell = pkgs.zsh;
          };

          environment.systemPackages = with pkgs; [
            libva-utils
          ];

          hardware = {
            nvidia.open = false;
          };

          home-manager = {
            extraSpecialArgs = {inherit inputs inputs';};
            users."omegaice".imports = [
              {
                home.username = "omegaice";
                home.packages = with pkgs; [
                  nil
                  pavucontrol
                ];
                # wayland.windowManager.hyprland.settings = {
                #   env = [
                #     "LIBVA_DRIVER_NAME,nvidia"
                #     "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                #     "NVD_BACKEND,direct"
                #   ];
                # };
              }
              ../../home
              ../../home/gtk.nix
              ../../home/editor/helix
              ../../home/programs/anyrun.nix
              ../../home/programs/firefox
              ../../home/programs/media
              ../../home/programs/vscode
              ../../home/programs/zoom.nix
              ../../home/programs/wayland/hyprland/default.nix
              ../../home/programs/wayland/hyprland/settings.nix
              ../../home/programs/wayland/dunst.nix
              ../../home/programs/wayland/hyprlock.nix
              ../../home/programs/wayland/waybar.nix
              ../../home/services/bluetooth.nix
              ../../home/terminal/emulators/kitty.nix
              ../../home/terminal/programs/bat.nix
              ../../home/terminal/programs/btop.nix
              ../../home/terminal/programs/eza.nix
              ../../home/terminal/programs/git.nix
              ../../home/terminal/programs/nix.nix
              ../../home/terminal/programs/xdg.nix
              ../../home/terminal/programs/yazi.nix
              ../../home/terminal/programs/zellij.nix
              ../../home/terminal/shell/atuin.nix
              ../../home/terminal/shell/nix-index.nix
              ../../home/terminal/shell/zsh.nix
              ../../home/terminal/shell/starship.nix
            ];
          };
        })
      ];
    });
}

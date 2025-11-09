{
  inputs,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations.t15g2 = withSystem "x86_64-linux" (
    ctx@{
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
        inherit inputs;
        inherit (ctx.config) packages;
        # Pass yaziPlugins from perSystem for use in home-manager modules
        yaziPlugins =
          let
            allmytoes = ctx.config.packages.allmytoes;
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          in
          pkgs.callPackage ../../packages/yazi-plugins {
            inherit allmytoes;
          };
      };
      modules = [
        inputs.determinate.nixosModules.default
        ./hardware-configuration.nix
        ../../system/core
        ../../system/core/boot.nix
        ../../system/hardware/backlight.nix
        ../../system/hardware/bluetooth.nix
        ../../system/hardware/fwupd.nix
        ../../system/hardware/intel-igpu.nix
        ../../system/hardware/monitoring.nix
        ../../system/hardware/nvidia.nix
        ../../system/hardware/power.nix
        ../../system/hardware/thunderbolt.nix
        ../../system/hardware/wifi/iwlwifi.nix
        ../../system/nix
        ../../system/network
        ../../system/programs/appimage.nix
        ../../system/programs/dconf.nix
        ../../system/programs/fonts.nix
        ../../system/programs/home-manager.nix
        ../../system/programs/hyprland.nix
        ../../system/programs/qt.nix
        # ../../system/programs/xdg.nix
        ../../system/programs/zfs.nix
        ../../system/programs/gaming
        ../../system/services/docker.nix
        ../../system/services/greetd.nix
        ../../system/services/gvfs.nix
        ../../system/services/logind.nix
        ../../system/services/ollama.nix
        ../../system/services/pipewire.nix
        ../../system/services/power.nix
        ../../system/services/seahorse.nix
        ../../system/services/ssh.nix
        ./home.nix
        (
          { pkgs, ... }:
          {
            networking.hostName = "t15g2";

            users.users.omegaice = {
              isNormalUser = true;
              home = "/home/omegaice";
              extraGroups = [
                "wheel"
                "networkmanager"
                "input"
                "docker"
                "video"
              ];
              shell = pkgs.zsh;
            };

            # Machine-specific packages
            environment.systemPackages = with pkgs; [
              brightnessctl # Laptop screen brightness control
              #samba4Full
              nwjs # For NW.js-based games
              libdecor
            ];

            environment.etc.hosts.mode = "0644";

            programs.nix-ld = {
              enable = true;
              libraries = with pkgs; [
                glib
                libxcursor
              ];
            };
          }
        )
      ];
    }
  );
}

{
  withSystem,
  inputs,
  ...
}: {
  flake = {
    homeConfigurations."jsweet" = withSystem "x86_64-linux" (ctx @ {
      pkgs,
      inputs',
      final,
      ...
    }: inputs.home-manager.lib.homeManagerConfiguration {
        inherit (ctx) pkgs;

        extraSpecialArgs = {inherit inputs;};

        modules = [
            {
                home.username = "jsweet";
                home.packages = with pkgs; [
                  nil
                ];

                targets.genericLinux.enable = true;
            }
            ../../home
            ../../home/editor/helix
            ../../home/terminal/programs/bat.nix
            ../../home/terminal/programs/btop.nix
            ../../home/terminal/programs/duf.nix
            ../../home/terminal/programs/eza.nix
            ../../home/terminal/programs/git.nix
            ../../home/terminal/programs/jq.nix
            ../../home/terminal/programs/nix.nix
            ../../home/terminal/programs/nodejs.nix
            ../../home/terminal/programs/rg.nixhomeManagerConfiguration
            ../../home/terminal/programs/xdg.nix
            ../../home/terminal/programs/yazi.nix
            ../../home/terminal/programs/zellij.nix
            ../../home/terminal/programs/zoxide.nix
            ../../home/terminal/shell/atuin.nix
            ../../home/terminal/shell/nix-index.nix
            ../../home/terminal/shell/zsh.nix
            ../../home/terminal/shell/starship.nix
        ];
    });
};
}
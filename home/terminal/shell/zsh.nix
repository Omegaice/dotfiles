{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      bindkey  "^[[3~"  delete-char

      zstyle :completion-sync:path enabled true
    '';
    shellAliases =
      {
        ip = "ip --color";
      }
      // lib.optionalAttrs config.programs.bat.enable {cat = "bat";};
    shellGlobalAliases = {eza = "eza --icons --git";};

    plugins = [
      {
        name = "zsh-completion-sync";
        file = "zsh-completion-sync.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "BronzeDeer";
          repo = "zsh-completion-sync";
          rev = "56448b301a7823e2e60b54116aa7640cfa8688d5";
          sha256 = "sha256-zDlmFaKU/Ilzcw6o22Hu9JFt8JKsER8idkb6QrtQKjI=";
        };
      }
    ];
  };
}

{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = lib.debug.traceVal true true;
    autosuggestion.enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    initExtra = ''
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      bindkey  "^[[3~"  delete-char
    '';
    shellAliases =
      {
        ip = "ip --color";
      }
      // lib.optionalAttrs config.programs.bat.enable {cat = "bat";};
    shellGlobalAliases = {eza = "eza --icons --git";};
  };
}

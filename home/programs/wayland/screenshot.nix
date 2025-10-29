{
  # Screenshot utility for Hyprland using grimblast (official hyprwm/contrib tool)
  # Provides --notify, --cursor, --freeze flags and editor integration
  # Saves to XDG Pictures directory by default
  programs.grimblast = {
    enable = true;
    # saveLocation defaults to null (uses XDG_PICTURES_DIR)
    # Note: flags are specified per-keybinding in hyprland/binds.nix
    # --cursor only works with active/output/screen targets, not with area
  };
}

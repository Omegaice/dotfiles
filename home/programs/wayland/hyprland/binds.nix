let
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    ) 10
  );

  toggle =
    program:
    let
      prog = builtins.substring 0 14 program;
    in
    "pkill ${prog} || uwsm app -- ${program}";

  runOnce = program: "pgrep ${program} || uwsm app -- ${program}";
in
{
  wayland.windowManager.hyprland.settings = {
    # mouse movements
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # binds
    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mod, Q, exec, ghostty +new-window"
      "$mod, C, killactive"
      "$mod, M, exit"
      "$mod, E, exec, nautilus"
      "$mod SHIFT, V, togglefloating" # Moved from $mod V to make room for clipboard
      "$mod, V, exec, ghostty --class=com.clipse -e clipse" # Open clipboard manager
      "$mod, R, exec, $menu"
      "$mod, P, pseudo, # dwindle"
      "$mod, J, togglesplit, # dwindle"

      # Special workspace for gaming - toggle game visibility while keeping position
      "$mod, G, togglespecialworkspace, game"
      "$mod SHIFT, G, movetoworkspace, special:game"

      # Screenshots using grimblast
      ", Print, exec, grimblast --notify copy area" # Select region → clipboard
      "SHIFT, Print, exec, grimblast --notify save area" # Select region → file
      "ALT, Print, exec, grimblast --notify --cursor save active" # Active window → file (with cursor)
      "CTRL, Print, exec, grimblast --notify --cursor save screen" # Full screen → file (with cursor)

      # Audio control tools
      "$mod, A, exec, pwvucontrol" # PipeWire volume control (most common)
      "$mod SHIFT, A, exec, qpwgraph" # Audio routing graph (advanced)
      "$mod CTRL, A, exec, easyeffects" # Audio effects and EQ (occasional)
    ]
    ++ workspaces;

    bindr = [
      # launcher
      "$mod, SUPER_L, exec, ${toggle "anyrun"}"
    ];

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # volume (with OSD via swayosd-client)
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
    ];

    bindle = [
      # volume (with OSD via swayosd-client)
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"

      # backlight (with OSD via swayosd-client)
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
    ];
  };
}

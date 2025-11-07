{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    env = [
      # "HYPRCURSOR_THEME,${cursorName}"
      # "HYPRCURSOR_SIZE,${toString pointer.size}"

      # "CLUTTER_BACKEND,wayland"
      # "GDK_BACKEND,wayland,x11,*"
      # "GDK_SCALE,1"
      # "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      # "QT_QPA_PLATFORM,wayland;xcb"
      # "QT_QPA_PLATFORMTHEME,qt6ct"
      # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      # "SDL_VIDEODRIVER,wayland"
      # "MOZ_ENABLE_WAYLAND,1"
      # "KWIN_DRM_USE_MODIFIERS,0"

      # NVIDIA variables removed - use Intel iGPU by default for offload mode
      # For NVIDIA rendering, use: nvidia-offload <application>
      # "LIBVA_DRIVER_NAME,nvidia"  # Removed - forces all apps to NVIDIA
      # "__GLX_VENDOR_LIBRARY_NAME,nvidia"  # Removed - keeps GPU always on
    ];

    exec-once = [
      # finalize startup
      "uwsm finalize"

      "clipse -listen"

      # set cursor for HL itself
      # "hyprctl setcursor ${cursorName} ${toString pointer.size}"
      "hyprlock"
    ];

    monitor = [
      "eDP-1, preferred, auto, 1" # Internal
      "DP-9, 5120x2160@72, auto-up, 1" # Work - explicit mode to avoid "NO PREFERRED MODE" error
    ];

    workspace = [
      "1, monitor:eDP-1, default:true"
      "2, monitor:eDP-1"
      "3, monitor:eDP-1"
      "4, monitor:eDP-1"
      "5, monitor:eDP-1"
      "6, monitor:DP-9"
      "7, monitor:DP-9"
      "8, monitor:DP-9"
      "9, monitor:DP-9"
      "10, monitor:DP-9"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
      resize_on_border = true;
    };

    decoration = {
      rounding = 16;
      blur = {
        enabled = false;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.01;

        vibrancy = 0.2;
        vibrancy_darkness = 0.5;

        passes = 4;
        size = 7;

        popups = true;
        popups_ignorealpha = 0.2;
      };

      shadow = {
        enabled = true;
        color = "rgba(00000055)";
        ignore_window = true;
        offset = "0 15";
        range = 100;
        render_power = 2;
        scale = 0.97;
      };
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    cursor = {
      no_hardware_cursors = true;
    };

    group = {
      groupbar = {
        font_size = 10;
        gradients = false;
        text_color = "rgb(b6c4ff)";
      };

      "col.border_active" = "rgba(35447988)";
      "col.border_inactive" = "rgba(dce1ff88)";
    };

    input = {
      numlock_by_default = true;

      follow_mouse = 0;
      accel_profile = "flat";
      touchpad = {
        scroll_factor = 0.75;
      };
    };

    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };

    device = {
      name = "synps/2-synaptics-touchpad";
      sensitivity = 1.5;
    };

    misc = {
      disable_splash_rendering = true;

      # disable auto polling for config file changes
      disable_autoreload = false;

      force_default_wallpaper = 0;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      vrr = 0;
    };

    # touchpad gestures
    gesture = [
      "3, horizontal, workspace" # 3-finger horizontal swipe to switch workspaces
    ];

    xwayland.force_zero_scaling = true;

    plugin = {
      hyprbars = {
        bar_height = 20;
        bar_precedence_over_border = true;

        # order is right-to-left
        hyprbars-button = [
          # close
          "rgb(ffb4ab), 15, , hyprctl dispatch killactive"
          # maximize
          "rgb(b6c4ff), 15, , hyprctl dispatch fullscreen 1"
        ];
      };

      hyprexpo = {
        columns = 3;
        gap_size = 4;
        bg_col = "rgb(000000)";

        enable_gesture = true;
        gesture_distance = 300;
        gesture_positive = false;
      };
    };
  };
}

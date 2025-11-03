{
  pkgs,
  lib,
}:
pkgs.writeShellApplication {
  name = "nw-generate-launcher";

  runtimeInputs = with pkgs; [
    coreutils
    findutils
    gnused
    gnugrep
  ];

  text = ''
    # Generator for NW.js game desktop files and launchers
    # Usage: nw-generate-launcher /path/to/game/directory

    GAME_DIR="''${1:?Usage: $0 /path/to/game/directory}"

    # Validate game directory
    if [ ! -d "$GAME_DIR" ]; then
        echo "Error: Directory not found: $GAME_DIR" >&2
        exit 1
    fi

    # Convert to absolute path
    GAME_DIR=$(cd "$GAME_DIR" && pwd)

    # Check for package.json
    PACKAGE_JSON="$GAME_DIR/package.json"
    if [ ! -f "$PACKAGE_JSON" ]; then
        echo "Error: package.json not found in $GAME_DIR" >&2
        exit 1
    fi

    # Parse package.json for game name
    GAME_NAME=$(grep -m1 '"displayName"' "$PACKAGE_JSON" | sed 's/.*"displayName"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    if [ -z "$GAME_NAME" ]; then
        GAME_NAME=$(grep -m1 '"name"' "$PACKAGE_JSON" | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
    fi

    if [ -z "$GAME_NAME" ]; then
        echo "Error: Could not extract game name from package.json" >&2
        exit 1
    fi

    # Find icon (common locations)
    ICON_PATH=""
    for icon_file in "$GAME_DIR/icon/icon.png" "$GAME_DIR/icon.png" "$GAME_DIR/assets/icon.png" "$GAME_DIR/www/icon/icon.png"; do
        if [ -f "$icon_file" ]; then
            ICON_PATH="$icon_file"
            break
        fi
    done

    # Generate desktop file ID (sanitize name)
    DESKTOP_ID=$(echo "$GAME_NAME" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd '[:alnum:]-')
    DESKTOP_FILE="$GAME_DIR/$DESKTOP_ID.desktop"

    echo "Generating files for: $GAME_NAME"
    echo "Game directory: $GAME_DIR"
    echo "Desktop file: $DESKTOP_FILE"

    # Generate .desktop file
    cat > "$DESKTOP_FILE" << EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=$GAME_NAME
    Comment=NW.js Game
    Exec=nw --class=nw-game .
    Path=$GAME_DIR
    Icon=''${ICON_PATH:-applications-games}
    Terminal=false
    Categories=Game;
    StartupWMClass=nw-game
    StartupNotify=true
    EOF

    echo "Created: $DESKTOP_FILE"

    # Generate launch.sh
    LAUNCH_SCRIPT="$GAME_DIR/launch.sh"
    cat > "$LAUNCH_SCRIPT" << 'LAUNCHER_EOF'
    #!/usr/bin/env bash
    # NW.js game launcher for Heroic Games Launcher
    # Reads .desktop file for launch command, handles process lifecycle

    # Get the directory where this script is located
    GAME_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"

    # Find the .desktop file in the same directory
    DESKTOP_FILE=$(find "$GAME_DIR" -maxdepth 1 -name "*.desktop" -type f | head -1)

    if [ -z "$DESKTOP_FILE" ]; then
        echo "Error: No .desktop file found in $GAME_DIR" >&2
        exit 1
    fi

    # Parse desktop file for Exec line and working directory
    EXEC_LINE=$(grep '^Exec=' "$DESKTOP_FILE" | head -1 | sed 's/^Exec=//')
    WORK_DIR=$(grep '^Path=' "$DESKTOP_FILE" | head -1 | sed 's/^Path=//')

    if [ -z "$EXEC_LINE" ]; then
        echo "Error: No Exec line found in desktop file" >&2
        exit 1
    fi

    # Change to the working directory
    cd "''${WORK_DIR:-$GAME_DIR}" || exit 1

    # Function to kill the game and all child processes
    cleanup() {
        if [ -n "$NW_PID" ] && kill -0 "$NW_PID" 2>/dev/null; then
            # Kill NW.js and all its children recursively
            pkill -TERM -P "$NW_PID"
            kill -TERM "$NW_PID" 2>/dev/null

            # Wait up to 5 seconds for graceful shutdown
            for i in {1..50}; do
                if ! kill -0 "$NW_PID" 2>/dev/null; then
                    exit 0
                fi
                sleep 0.1
            done

            # Force kill if still running
            pkill -KILL -P "$NW_PID"
            kill -KILL "$NW_PID" 2>/dev/null
        fi
        exit 0
    }

    # Trap signals from Heroic
    trap cleanup SIGTERM SIGINT SIGHUP

    # Launch game using command from desktop file
    $EXEC_LINE &
    NW_PID=$!

    # Wait for the game to finish
    wait "$NW_PID"
    EXIT_CODE=$?

    exit "$EXIT_CODE"
    LAUNCHER_EOF

    chmod +x "$LAUNCH_SCRIPT"
    echo "Created: $LAUNCH_SCRIPT"

    # Create symlink in applications directory
    APPS_DIR="$HOME/.local/share/applications"
    mkdir -p "$APPS_DIR"
    SYMLINK_PATH="$APPS_DIR/$DESKTOP_ID.desktop"

    if [ -L "$SYMLINK_PATH" ]; then
        rm "$SYMLINK_PATH"
    fi

    ln -s "$DESKTOP_FILE" "$SYMLINK_PATH"
    echo "Created symlink: $SYMLINK_PATH -> $DESKTOP_FILE"

    echo ""
    echo "✓ Setup complete!"
    echo ""
    echo "To launch from Heroic:"
    echo "  Set executable to: $LAUNCH_SCRIPT"
    echo ""
    echo "To launch from anyrun/rofi:"
    echo "  Search for: $GAME_NAME"
  '';

  meta = with lib; {
    description = "Generate .desktop files and launch scripts for NW.js games";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

{ pkgs }:

pkgs.writeShellScriptBin "zen" ''
  STATE_FILE="''${XDG_RUNTIME_DIR}/zen_mode_active"

  if [[ -f "$STATE_FILE" ]]; then
      # turn zen off
      hyprctl reload
      pkill -USR1 waybar
      rm "$STATE_FILE"
  else
      # turn zen on
      hyprctl keyword general:gaps_in 0
      hyprctl keyword general:gaps_out 0
      hyprctl keyword general:border_size 0
      hyprctl keyword decoration:rounding 0
      pkill -USR1 waybar
      touch "$STATE_FILE"
  fi
''

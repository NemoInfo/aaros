{ pkgs }:
pkgs.writeShellScriptBin "unicode-list" ''
  UNICODE_DATA=${pkgs.unicode-character-database}/share/unicode/UnicodeData.txt

  # Check if UnicodeData.txt exists
  if [ ! -f "$UNICODE_DATA" ]; then
      rofi -config ~/.config/rofi/config-long.rasi -e "Error: UnicodeData.txt not found at $UNICODE_DATA"
      exit 1
  fi

  if command -v wl-copy &> /dev/null; then
      CLIPBOARD_CMD="wl-copy"
  else
      rofi -config ~/.config/rofi/config-long.rasi -e "Error: wl-copy is not installed."
      exit 1
  fi

  # Process UnicodeData.txt and format for rofi
  # Format: CHARACTER | U+CODEPOINT | NAME
  selected=$(awk -F';' '{
      # Convert hex codepoint to decimal
      codepoint = "0x" $1
      decimal = strtonum(codepoint)
      
      # Get the character (skip control characters and some ranges)
      if (decimal >= 32 && decimal != 127) {
          char = sprintf("%c", decimal)
          # Format: character | U+codepoint | name
          printf "%s | U+%s | %s\n", char, $1, $2
      } else {
          # For control characters, just show the info without the character
          printf "   | U+%s | %s\n", $1, $2
      }
  }' "$UNICODE_DATA" | rofi -i -dmenu -config ~/.config/rofi/config-long.rasi -p "Unicode Character" -format "s")

  # If user selected something, copy the character to clipboard
  if [ -n "$selected" ]; then
      # Extract just the character (first field before the |)
      character=$(echo "$selected" | awk -F' | ' '{print $1}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      
      # Copy to clipboard
      if [ -n "$character" ]; then
          echo -n "$character" | $CLIPBOARD_CMD
          
          # Show notification (optional, requires notify-send)
          if command -v notify-send &> /dev/null; then
              codepoint=$(echo "$selected" | awk -F' | ' '{print $2}')
              name=$(echo "$selected" | awk -F' | ' '{print $3}')
              notify-send --transient "Unicode Copied" "$character ($codepoint)\n$name"
          fi
      fi
  fi
''

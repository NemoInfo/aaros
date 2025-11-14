{ pkgs }:
pkgs.writeShellScriptBin "web-search" ''
  # check if rofi is already running
  if pidof rofi > /dev/null; then
    pkill rofi
  fi

  declare -A URLS

  URLS=(
    [" Google Scholar"]="https://scholar.google.com/?authuser=1"
    [" YouTube"]="https://www.youtube.com/results?search_query="
    ["󱄅 NixOs Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
    ["󱁉 ChatGPT"]="https://chatgpt.com/"
  )

  # List for rofi
  gen_list() {
    for i in "''${!URLS[@]}"
    do
      echo "$i"
    done
  }

  main() {
    # Pass the list to rofi
    platform=$( (gen_list) | ${pkgs.rofi-wayland}/bin/rofi -i -dmenu -config ~/.config/rofi/config-long.rasi )

    if [[ -n "$platform" ]]; then
      query=$(${pkgs.rofi-wayland}/bin/rofi -i -dmenu -config ~/.config/rofi/config-long.rasi)

      if [[ -n "$query" ]]; then
        url=''${URLS[$platform]}$query
        xdg-open "$url"
      else
        exit
      fi
    else
      exit
    fi
  }

   main

   exit 0
''

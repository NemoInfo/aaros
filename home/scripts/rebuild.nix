{ pkgs }:
pkgs.writeShellScriptBin "rebuild" ''
  exec "${./rebuild.sh}" "$@"
''

# Lazygit is a simple terminal UI for git commands.
{ pkgs, host, lib, ... }:
let
  inherit (import ../hosts/${host}/colors.nix { inherit pkgs; }) colors;
  accent = "#${colors.base0D}";
  muted = "#${colors.base03}";
in {
  programs.lazygit = {
    enable = true;
    settings = lib.mkForce {
      disableStartupPopups = true;
      quitOnTopLevelReturn = true;
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      update.method = "never";
      git = {
        commit.signOff = true;
        parseEmoji = true;
      };
      gui = {
        theme = {
          activeBorderColor = [ accent "bold" ];
          inactiveBorderColor = [ muted ];
        };
        showListFooter = false;
        showRandomTip = false;
        showCommandLog = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
      };
    };
  };
}

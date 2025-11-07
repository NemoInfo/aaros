# SDDM is a display manager for X11 and Wayland
{ pkgs, lib, host, ... }:
let
  inherit (import ../hosts/${host}/colors.nix { inherit pkgs; }) colors;
  foreground = colors.base00;
  textColor = colors.base05;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = if lib.hasSuffix "sakura_static.png" colors.image then {
      FormPosition = "left";
      Blur = "2.0";
      HourFormat = "h:mm AP";
    } else if lib.hasSuffix "studio.png" colors.image then {
      Background = pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/anotherhadi/nixy-wallpapers/refs/heads/main/wallpapers/studio.gif";
        sha256 = "sha256-qySDskjmFYt+ncslpbz0BfXiWm4hmFf5GPWF2NlTVB8=";
      };
      HourFormat = "h:mm AP";
      HeaderTextColor = "#${textColor}";
      DateTextColor = "#${textColor}";
      TimeTextColor = "#${textColor}";
      LoginFieldTextColor = "#${textColor}";
      PasswordFieldTextColor = "#${textColor}";
      UserIconColor = "#${textColor}";
      PasswordIconColor = "#${textColor}";
      WarningColor = "#${textColor}";
      LoginButtonBackgroundColor = "#${foreground}";
      SystemButtonsIconsColor = "#${foreground}";
      SessionButtonTextColor = "#${textColor}";
      VirtualKeyboardButtonTextColor = "#${textColor}";
      DropdownBackgroundColor = "#${foreground}";
      HighlightBackgroundColor = "#${textColor}";
    } else {
      FormPosition = "left";
      Blur = "4.0";
      Background = "${toString colors.image}";
      HourFormat = "h:mm AP";
      HeaderTextColor = "#${textColor}";
      DateTextColor = "#${textColor}";
      TimeTextColor = "#${textColor}";
      LoginFieldTextColor = "#${textColor}";
      PasswordFieldTextColor = "#${textColor}";
      UserIconColor = "#${textColor}";
      PasswordIconColor = "#${textColor}";
      WarningColor = "#${textColor}";
      LoginButtonBackgroundColor = "#${colors.base01}";
      SystemButtonsIconsColor = "#${textColor}";
      SessionButtonTextColor = "#${textColor}";
      VirtualKeyboardButtonTextColor = "#${textColor}";
      DropdownBackgroundColor = "#${colors.base01}";
      HighlightBackgroundColor = "#${textColor}";
      FormBackgroundColor = "#${colors.base01}";
    };
  };
in {
  programs.hyprland.enable = true;
  services.displayManager = {
    sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = [ sddm-astronaut ];
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
    };
  };

  environment.systemPackages = [ sddm-astronaut ];
}

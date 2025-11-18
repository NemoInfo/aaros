{ lib, pkgs, ... }: {
  imports = [
    ./hyprland
    ./nvim
    ./alacritty.nix
    ./ghostty.nix
    ./git.nix
    ./zsh.nix
    ./packages.nix
    ./waybar.nix
    ./swaync.nix
    ./rofi
    ./scripts
    ./fastfetch
    ./gtk.nix
    ./stylix.nix
    ./swappy.nix
    ./zoxide.nix
  ];
  home.file.".config/sioyek/prefs_user.config".source = ./sioyek.config;

  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "qtct";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = { enable = true; };
    autostart = { }; # nm-applet
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };
  };
}

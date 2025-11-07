{ lib, pkgs, username, ... }: {
  imports = [
    ./hyprland
    ./nvim
    ./alacritty.nix
    ./git.nix
    ./zsh.nix
    ./packages.nix
    ./waybar/waybar-jerry.nix
    ./swaync.nix
    ./rofi
    ./scripts
  ];

  home.file.".config/sioyek/prefs_user.config".source = ./sioyek.config;
  #
  #  programs = {
  #    zoxide = {
  #      enable = true;
  #      enableZshIntegration = true;
  #      enableBashIntegration = true;
  #      options = [ "--cmd cd" ];
  #    };
  #  };
  #
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "qtct";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = { enable = true; };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };
  };
}

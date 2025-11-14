{ lib, pkgs, ... }: {
  imports = [
    ./hyprland
    ./nvim
    ./alacritty.nix
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
  ];

  home.file.".config/sioyek/prefs_user.config".source = ./sioyek.config;
  # home.file.".config/swappy/config".text = ''
  #   [default]
  #   save_dir=/home/${username}/pictures/screenshots
  #   save_filename_format=swappy-%y%m%d-%h%m%s.png
  #   show_panel=false
  #   line_size=5
  #   text_size=20
  #   text_font=ubuntu
  #   paint_mode=brush
  #   early_exit=true
  #   fill_shape=false
  # '';

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

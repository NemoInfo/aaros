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
    ./eza.nix
    ./lazygit.nix
    ./syncthing.nix
    ./tmux
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

  programs.sftpman = {
    enable = true;
    mounts = {
      pi = {
        host = "192.168.0.222";
        port = 22;
        user = "wukong";
        mountDestPath = "/home/aaron/wukong";
        mountPoint = "/home/wukong";
        authType = "publickey";
        sshKey = "/home/aaron/.ssh/id_ed25519_pi";
      };
      pi-global = {
        host = "5.65.50.56";
        port = 22;
        user = "wukong";
        mountDestPath = "/home/aaron/wukong";
        mountPoint = "/home/wukong";
        authType = "publickey";
        sshKey = "/home/aaron/.ssh/id_ed25519_pi";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com 
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes 
      Host wukong-local
        HostName 192.168.0.222
        User wukong
        IdentityFile ~/.ssh/id_ed25519_pi
        ConnectTimeout 3
      Host wukong-global
        HostName 5.65.50.56
        User wukong
        IdentityFile ~/.ssh/id_ed25519_pi
        ConnectTimeout 10
    '';
  };
}

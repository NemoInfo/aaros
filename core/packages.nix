{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ brightnessctl cliphist ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    firefox.enable = false;
    hyprland = {
      enable = true;
      withUWSM = false;
    };
    fuse.userAllowOther = true;
    hyprlock.enable = true;
  };
}

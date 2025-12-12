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
      package = pkgs.hyprland.override {
        aquamarine = pkgs.aquamarine.overrideAttrs (old: {
          patches = [
            (pkgs.fetchpatch {
              hash = "sha256-QaAYziKhXyswQJdiBSHehbj39wXkHHbPA1sEg0rHVD4=";
              includes = [ "src/allocator/GBM.cpp" ];
              revert = true;
              url =
                "https://github.com/hyprwm/aquamarine/commit/b058847592e5fb3f121ef909601ab635247a0d1c.patch";
            })
          ];
        });
      };
      withUWSM = false;
    };
    fuse.userAllowOther = true;
    hyprlock.enable = true;
  };
}

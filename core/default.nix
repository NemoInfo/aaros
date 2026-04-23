{ inputs, ... }: {
  imports = [
    ./boot.nix
    ./system.nix
    ./hardware.nix
    ./home.nix
    ./xserver.nix
    ./sddm.nix
    ./network.nix
    ./packages.nix
    ./services.nix
    ./stylix.nix
    ./thunar.nix
    inputs.stylix.nixosModules.stylix
  ];
}

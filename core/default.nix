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
    ./syncthing.nix
    ./services.nix
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
  ];
}

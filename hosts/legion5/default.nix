{ ... }: {
  imports = [
    ./hardware.nix # Because this is a VM maybe I don't need it
    ./host-packages.nix
  ];
}

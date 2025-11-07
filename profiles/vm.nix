{ host, ... }: {
  imports = [ ../hosts/${host} ../drivers ../core ];

  # drivers.nvidia-amd.enable = false;
  vm.guest-services.enable = true;
}

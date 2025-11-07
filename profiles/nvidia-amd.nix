{ host, ... }:
let inherit (import ../hosts/${host}/variables.nix) amdgpuID nvidiaID;
in {
  imports = [ ../hosts/${host} ../drivers ../core ];

  drivers.nvidia-amd = {
    enable = true;
    amdgpuBusID = "${amdgpuID}";
    nvidiaBusID = "${nvidiaID}";
  };
}

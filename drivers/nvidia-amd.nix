{ config, lib, pkgs, ... }:

with lib;
let cfg = config.drivers.nvidia-amd;
in {
  options.drivers.nvidia-amd = {
    enable = mkEnableOption "Enable AMD iGPU + NVIDIA dGPU (Prime offload)";
    # AMD iGPU Bus ID (e.g., PCI:5:0:0). Expose as option for future host wiring.
    amdgpuBusID = mkOption {
      type = types.str;
      default = "PCI:5:0:0";
      description = "PCI Bus ID for AMD iGPU (amdgpuBusId)";
    };
    # NVIDIA dGPU Bus ID (e.g., PCI:1:0:0)
    nvidiaBusID = mkOption {
      type = types.str;
      default = "PCI:1:0:0";
      description = "PCI Bus ID for NVIDIA dGPU (nvidiaBusId)";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    # Enforce kernel 6.12 when this hybrid config is selected
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

    services.xserver.videoDrivers = [ "nvidia" "modesetting" "vesa" ];

    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      prime = {
        offload = { # AMD primary, NVIDIA offload
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = cfg.amdgpuBusID;
        nvidiaBusId = cfg.nvidiaBusID;
      };
    };

    #   hardware.nvidia = {
    #     modesetting.enable = true;
    #     open = false;
    #     nvidiaSettings = true;
    #     package = config.boot.kernelPackages.nvidiaPackages.latest;
    #     powerManagement.enable = true;
    #     powerManagement.finegrained = false;
    #   };

  };
}

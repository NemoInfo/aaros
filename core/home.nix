{ pkgs, inputs, username, host, profile, system, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host profile system; };
    users.${username} = {
      imports = [ ../home ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "docker" # access to docker as non-root
      "libvirtd" # Virt manager/QEMU access
      "lp"
      "networkmanager"
      "scanner"
      "wheel" # sudo access
      "vboxusers" # Virtual Box
      "syncthing"
      "tty"
      "dialout"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  programs.zsh.enable = true;
  nix.settings.allowed-users = [ "${username}" ];
}

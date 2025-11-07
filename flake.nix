{
  description = "Aaron-OS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "legion5";
      profile = "legion5";
      username = "aaron";

      mkNixosConfig = gpuProfile:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username host profile; };
          modules = [ ./profiles/${gpuProfile}.nix ];
        };
    in {
      nixosConfigurations = {
        vm = mkNixosConfig "vm";
        nvidia-amd = mkNixosConfig "nvidia-amd";
      };

      # homeConfigurations."${username}" =
      #   home-manager.lib.homeManagerConfiguration {
      #     extraSpecialArgs = { inherit inputs username host system; };
      #     modules = [ ./home ];
      #   };
    };
}

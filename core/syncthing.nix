{ username, nixpkgs-unstable, system, ... }:
let _unstable = import nixpkgs-unstable { system = system; };
in {
  services.syncthing = {
    # package = unstable.syncthing;
    enable = true;
    user = "${username}";
    configDir = "/home/${username}/.config/syncthing";
    openDefaultPorts = true;
    settings = {
      devices = {
        ipad.id =
          "5TXZOVM-6H3VBNO-CV63ZNF-SV3G4GQ-MJLI4QY-Z5IPOAH-G7TWCXB-OMZAUQV";
        phone.id =
          "V27G7DT-V56JRVN-UDE4MHF-3HVD3TU-XQ4S55I-CHEQ4GF-PNMOFRO-4RQRLAH";
      };
      folders = {
        "Vault" = {
          path = "/home/aaron/Vault";
          devices = [ "ipad" "phone" ];
          ignorePerms = false;
          type = "sendreceive";
        };
      };
    };
    extraFlags = [ "--no-default-folder" ];
  };
}

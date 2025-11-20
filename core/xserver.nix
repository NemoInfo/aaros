{ host, ... }:
let inherit (import ../hosts/${host}/variables.nix) keyboardLayout;
in {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "${keyboardLayout}";
      variant = "";
    };
  };
}

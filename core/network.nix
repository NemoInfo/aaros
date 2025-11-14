{ pkgs, host, ... }: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    firewall = rec {
      enable = true;
      allowedTCPPorts = [ 22 80 443 59010 59011 8080 ];
      allowedUDPPorts = [ 59010 59011 ];
      allowedTCPPortRanges = [{
        from = 1714;
        to = 1764;
      }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}

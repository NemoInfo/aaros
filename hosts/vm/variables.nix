{
  gitUsername = "dwilliams";
  gitEmail = "don.e.williams@gmail.com";
  extraMonitorSettings = ''
    monitor = eDP-2, 1920x1080@165, 0x0, 1
    monitor = HDMI-A-1, 2560x1440@144, 1920x0, 1
  '';
  keyboardLayout = "gb,eu";
  nvidiaID = "PCI:1:0:0";
  amdgpuID = "PCI:5:0:0";
  browser = "goog-chrome-stable";
  terminal = "ghostty";
}

{ pkgs, ... }:
# let unstable = import inputs.nixpkgs-unstable { system = system; }; in
{
  programs.tmux = {
    enable = true;
    shortcut = "space";
    plugins = with pkgs.tmuxPlugins; [];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}

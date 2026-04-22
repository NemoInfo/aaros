{pkgs, ...} : {
  programs.tmux = {
    enable = true;
    shortcut = "\\;";
    plugins = with pkgs.tmuxPlugins; [
      kanagawa
    ];

    extraConfig = with pkgs.tmuxPlugins; ''
      run-shell '${kanagawa}/share/tmux-plugins/kanagawa/kanagawa.tmux'

      set -g @ukiyo-theme "kanagawa/wave"
      set -g @ukiyo-ignore-window-colors true
    '';
  };
}

{ ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
  };
  home.file."./.config/ghostty/config".text = ''
    theme = Kanagawa Wave
    window-theme = dark
    background= #000000
    background-opacity = 0.75
    background-blur-radius = 40
    cursor-style = bar

    wait-after-command = false
    shell-integration = detect
    window-save-state = always
    gtk-single-instance = true
    unfocused-split-opacity = 0.5
    quick-terminal-position = center
    shell-integration-features = cursor,sudo

    font-size = 14
    font-family = JetBrainsMono Nerd Font Mono
    font-family-bold = JetBrainsMono NFM Bold
    font-family-italic = JetBrainsMono NFM Italic
    font-family-bold-italic = JetBrainsMono NFM Bold Italic

    keybind = alt+k=jump_to_prompt:-1
    keybind = alt+j=jump_to_prompt:1
  '';
}

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    shellAliases = {
      "haya" = ''
        clippaste > /tmp/thing.bib && hayagriva /tmp/thing.bib | clipcopy && echo "✔ YAML copied to clipboard"'';
    };
    initContent = ''
      if [[ -n "$IN_NIX_SHELL" ]]; then
        ZSH_THEME="cloud"
      fi
      if [[ -n "$THEME" ]]; then
        ZSH_THEME="$THEME"
      fi
      source $ZSH/oh-my-zsh.sh

      eval "$RUN"
    '';
  };
}

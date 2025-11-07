{ pkgs, latest, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      lualine-nvim
      rose-pine
      telescope-fzf-native-nvim
      kanagawa-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      nvim-lspconfig
      cmp-buffer
      cmp-path
      cmp-cmdline
      none-ls-nvim
      nvim-web-devicons
      oil-nvim
      alpha-nvim
      vimtex
      lazygit-nvim
      vim-fugitive
      rust-tools-nvim
      coc-ltex
      julia-vim
      typst-vim
      nvim-ufo
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-textsubjects
      lexima-vim
      hex-nvim
      asyncrun-vim
      vim-floaterm
      nvim-surround
      leap-nvim
      typst-preview-nvim
      typst-vim
    ];
  };

  home.file.".config/nvim/init.lua".source = ./init.lua;
}

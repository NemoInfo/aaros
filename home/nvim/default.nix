{ pkgs, system, inputs, ... }:
let unstable = import inputs.nixpkgs-unstable { system = system; };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = let
      l1 = with unstable.vimPlugins; [ typst-preview-nvim typst-vim ];
      l2 = with pkgs.vimPlugins; [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
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
        rustaceanvim
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
        lsp-inlayhints-nvim
        vim-visual-multi
        vim-easy-align
      ];
    in l1 ++ l2;
  };

  home.file.".config/nvim/".source = ../nvim;
}

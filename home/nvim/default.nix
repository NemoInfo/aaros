{ pkgs, system, inputs, ... }:
let unstable = import inputs.nixpkgs-unstable { system = system; };
  jai-vim = pkgs.vimUtils.buildVimPlugin {
    name = "jai-vim";
    src = pkgs.fetchFromGitHub {
      owner = "rluba";
      repo = "jai.vim";
      rev = "master";
      sha256 = "sha256-VFNIcJmz44y/1TzJ8IpB5US5VYZwWL7FhjZC4vKOuoQ=";
    };
  };
  typcite-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "typcite.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "StephanoGit";
      repo = "typcite.nvim";
      rev = "main";
      sha256 = "sha256-Qdch5TsafFCkUJ3Zl3/Fxu/HFQdQdJC4Q9VFG1un4gc="; 
    };
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = let
      l1 = with unstable.vimPlugins; [ typst-preview-nvim typst-vim typcite-nvim ];
      l2 = with pkgs.vimPlugins; [
        jai-vim
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
        lean-nvim
      ];
    in l1 ++ l2;
  };

  home.file.".config/nvim/".source = ../nvim;
}

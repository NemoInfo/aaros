{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # apps
    sioyek
    google-chrome
    firefox
    gimp
    alacritty
    discord
    inkscape
    obs-studio
    vlc
    # bottles
    # virtualbox
    steam
    syncthing
    qemu
    quickemu

    # Fonts
    libertinus # TODO: move these to system fonts
    liberation_ttf
    icon-library
    # cli tools
    ripgrep
    lazygit
    fastfetch
    cmatrix
    railway
    cloc
    tree
    (btop.override { cudaSupport = true; })
    helix
    wgnord

    # languages
    gcc # C compiler
    clang-tools # CPP lsp
    nil # Nix lsp
    haskellPackages.nixfmt # Nix fmt
    lua-language-server # Lua lsp
    stylua # Lua fmt
    pyright # Python Lsp
    yapf # Pythin fmt
    rust-analyzer # Rust lsp
    rustfmt # Rust fmt
    rustc # Rust compiler
    cargo # Rust dependecy manager
    cudatoolkit
    typst # f*ck latex
    tinymist
    hayagriva

    gh
  ];
}

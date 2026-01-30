{ pkgs, inputs, system, ... }:
let unstable = import inputs.nixpkgs-unstable { system = system; };
in {
  nixpkgs.config.allowUnfree = true;
  home.packages = let
    l1 = with unstable; [ typst tinymist ];
    l2 = with pkgs; [
      syncthing
      # apps
      sioyek
      google-chrome
      firefox
      gimp
      discord
      inkscape
      obs-studio
      vlc
      modrinth-app

      # bottles
      # virtualbox
      steam
      qemu
      quickemu
      zoom-us
      libnotify
      rofi-bluetooth
      pavucontrol
      glava

      # Fonts
      libertinus # TODO: move these to system fonts
      liberation_ttf
      icon-library
      # cli tools
      ripgrep
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
      hayagriva
      unicode-character-database
      jre_minimal

      gh # github, why tough?
      direnv
    ];
  in l1 ++ l2;
}

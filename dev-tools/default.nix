{ pkgs, naersk-lib }:

with pkgs;

let
  rnix = naersk-lib.buildPackage {
    pname = "rnix-lsp";
    root = builtins.fetchTarball {
      url = "https://github.com/nix-community/rnix-lsp/archive/refs/tags/v0.2.5.tar.gz";
      sha256 = "128h2jih911wvf2pa5g7ryviylapbzvi446xw92qkf8xz3cn6yjr";
    };
    doCheck = false;
    checkInputs = [ pkgs.nix ];
  };

  python = python310;
  pyPkgs = (
    python.withPackages (p: with p; [
      mccabe
      pycodestyle
      pyflakes
      python-lsp-server
      rope
      yapf
    ])
  );

  templates = import ./templates.nix { inherit pkgs sbcl zsh bun; };

  # haskellPackages = haskell.packages.ghc902.extend (self: super: {
  #   fourmolu = super.fourmolu.overrideAttrs (old: {
  #     version = "0.10.1.0";
  #   });
  # });

  # hls = haskellPackages.haskell-language-server;

  # ghc-name = "${haskellPackages.ghc.pname}-${haskellPackages.ghc.version}";

  system-name = stdenv.targetPlatform.system;

in
mkShell rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    alsa-lib
    curl
    editorconfig-core-c
    # emacs-nox
    git
    # haskellPackages.apply-refact
    # haskellPackages.cabal-fmt
    # haskellPackages.cabal-install
    # haskellPackages.hasktags
    # haskellPackages.hlint
    # haskellPackages.hoogle
    # haskellPackages.stylish-haskell
    # hls
    ipfs
    jq
    jsonnet
    neovim
    ninja
    nixfmt
    nodejs
    pkg-config
    pyPkgs
    python
    rnix
    sbcl
    silver-searcher
    templates.dev-shell
    tmux
    udev
    unzip
    vim
    wget
    zig
    zls
  ];

  # shellHook = ''
  #   export LD_LIBRARY_PATH=${hls.outPath}/lib/${ghc-name}/${system-name}-${ghc-name}:$LD_LIBRARY_PATH
  # '';
}

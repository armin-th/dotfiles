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
      python-lsp-server
    ])
  );

  sbcl-buildapp =
    stdenv.mkDerivation rec {
      pname = "buildapp";
      version = "1.5.6";
      buildInputs = [ sbcl ];
      src = builtins.fetchurl {
        url = "https://github.com/xach/${pname}/archive/refs/tags/release-${version}.tar.gz";
        sha256 = "1vd3sq1wnhkdhwq2qblpmygpvzpp0s10bbq9p5hacpb0a70vczyp";
      };
      makeFlags = [ "DESTDIR=$(out)" ];
      configurePhase = ''
        export SBCL_HOME=${sbcl.outPath}/lib/sbcl
      '';
      preInstall = ''
        mkdir -p $out/bin
      '';
      dontFixup = true;
    };

  templates = import ./templates.nix { inherit pkgs sbcl zsh bun; };

  haskellPackages = haskell.packages.ghc902.extend (self: super: {
    fourmolu = super.fourmolu.overrideAttrs (old: {
      version = "0.10.1.0";
    });
  });

  hls = haskellPackages.haskell-language-server;

  ghc-name = "${haskellPackages.ghc.pname}-${haskellPackages.ghc.version}";

  system-name = stdenv.targetPlatform.system;

in
mkShell rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    bun
    cargo
    clang
    curl
    editorconfig-core-c
    emacs-nox
    git
    haskellPackages.apply-refact
    haskellPackages.cabal-install
    haskellPackages.hasktags
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.stylish-haskell
    hls
    ipfs
    jq
    jsonnet
    neovim
    nixfmt
    nodejs
    pkg-config
    protobuf
    pyPkgs
    python
    rnix
    rust-analyzer
    rustc
    rustfmt
    sbcl
    sbcl-buildapp
    silver-searcher
    sumneko-lua-language-server
    templates.dev-shell
    tmux
    vim
    wget
    zig
    zls
    zsh
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${hls.outPath}/lib/${ghc-name}/${system-name}-${ghc-name}:$LD_LIBRARY_PATH
  '';
}

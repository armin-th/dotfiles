{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
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
        url="https://github.com/xach/${pname}/archive/refs/tags/release-${version}.tar.gz";
        sha256="1vd3sq1wnhkdhwq2qblpmygpvzpp0s10bbq9p5hacpb0a70vczyp";
      };
      makeFlags = [ "DESTDIR=$(out)" ];
      configurePhase=''
        export SBCL_HOME=${sbcl.outPath}/lib/sbcl
      '';
      preInstall = ''
        mkdir -p $out/bin
      '';
      dontFixup = true;
    };

  templates = import ./templates.nix { inherit pkgs sbcl zsh; };

  haskellPackages = haskell.packages.ghc902;

  hls-src = builtins.fetchTarball {
    url = "https://github.com/haskell/haskell-language-server/archive/refs/tags/1.7.0.0.tar.gz";
    sha256 = "14dd0c7jm43yy7mhzsl7b92hz01l36ayq8rnch0q1p6a3xz2qb5s";
  };

  hls = (haskellPackages.callCabal2nix "haskell-language-server" hls-src {})
    .overrideAttrs(old: {
      doCheck = false;
      dontFixup = true;
      dontStrip = true;
    });

  ghc-name = "${haskellPackages.ghc.pname}-${haskellPackages.ghc.version}";

  system-name = stdenv.targetPlatform.system;

in mkShell rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
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
    haskellPackages.stack
    haskellPackages.stylish-haskell
    hls
    jsonnet
    nixfmt
    nodejs
    pkg-config
    protobuf
    pyPkgs
    python
    rust-analyzer
    rustc
    rustfmt
    sbcl
    sbcl-buildapp
    templates.dev-shell
    tmux
    vim
    wget
    zsh
    zig
    zls
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${hls.outPath}/lib/${ghc-name}/${system-name}-${ghc-name}:$LD_LIBRARY_PATH
  '';
}

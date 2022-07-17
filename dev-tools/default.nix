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
  ];
}

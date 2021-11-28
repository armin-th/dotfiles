{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  python = python38.override ({
    self = python;
    packageOverrides = self: super: rec {
      parso = (super.buildPythonPackage rec {
        pname = "parso";
        version = "0.7.1";

        buildInputs = [ super.pytest ];

        src = super.fetchPypi {
          inherit pname version;
          sha256 =
            "caba44724b994a8a5e086460bb212abc5a8bc46951bf4a9a1210745953622eb9";
        };
      });
      jedi = (super.buildPythonPackage rec {
        pname = "jedi";
        version = "0.17.2";

        buildInputs = [ parso ];

        doCheck = false;

        src = super.fetchPypi {
          inherit pname version;
          sha256 =
            "86ed7d9b750603e4ba582ea8edc678657fb4007894a12bcf6f4bb97892f31d20";
        };
      });
      python-lsp-server = (super.buildPythonPackage rec {
        pname = "python-lsp-server";
        version = "1.2.4";

        buildInputs = [
          jedi
          parso
          super.autopep8
          super.flake8
          super.flaky
          super.mccabe
          super.mock
          super.pluggy
          super.pycodestyle
          super.pydocstyle
          super.pyflakes
          super.pylint
          super.pytest
          super.python-jsonrpc-server
          super.python-lsp-jsonrpc
          super.rope
          super.yapf
        ];

        src = super.fetchPypi {
          inherit pname version;
          sha256 =
            "007278c4419339bd3a61ca6d7eb8648ead28b5f1b9eba3b6bae8540046116335";
        };
      });
      python-language-server = (super.buildPythonPackage rec {
        pname = "python-language-server";
        version = "0.36.2";

        buildInputs = [
          jedi
          parso
          super.autopep8
          super.flake8
          super.flaky
          super.mccabe
          super.mock
          super.pluggy
          super.pycodestyle
          super.pydocstyle
          super.pyflakes
          super.pylint
          super.pytest
          super.python-jsonrpc-server
          super.python-lsp-jsonrpc
          super.rope
          super.yapf
        ];

        src = super.fetchPypi {
          inherit pname version;
          sha256 =
            "9984c84a67ee2c5102c8e703215f407fcfa5e62b0ae86c9572d0ada8c4b417b0";
        };
      });
      pyls-black = super.pyls-black.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ])
          ++ [ jedi parso super.python-jsonrpc-server ];
      });
      pyls-isort = super.pyls-isort.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          jedi
          parso
          super.pluggy
          super.python-jsonrpc-server
          super.python-lsp-jsonrpc
          super.ujson
        ];
      });
      pyls-mypy = super.pyls-mypy.overridePythonAttrs (old: {
        buildInputs = (old.buildInputs or [ ])
          ++ [ jedi parso super.pluggy super.python-jsonrpc-server ];
      });
    };
  });
  pyPkgs = (python.withPackages (p:
    with p; [
      flake8
      jedi
      parso
      pluggy
      pyls-black
      pyls-isort
      pyls-mypy
      python-language-server
      python-lsp-jsonrpc
      setuptools
    ]));
  ocamlclean = callPackage (
    { lib, fetchurl, buildDunePackage }:
      buildDunePackage rec {
        pname = "ocamlclean";
        version = "2.2";

        useDune2 = true;

        minimalOCamlVersion = "4.13";

        src = fetchurl {
          url =
            "http://www.algo-prog.info/ocapic/web/lib/exe/fetch.php?media=ocapic:ocamlclean-2.2.tar.bz2";
          sha256 = "09ygcxxd5warkdzz17rgpidrd0pg14cy2svvnvy1hna080lzg7vp";

        };
      }
    );

in pkgs.stdenv.mkDerivation rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    cargo
    curl
    editorconfig-core-c
    emacs-nox
    git
    haskellPackages.apply-refact
    haskellPackages.cabal-install
    haskellPackages.ghc
    haskellPackages.hasktags
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.proto-lens-protoc
    haskellPackages.stack
    haskellPackages.stylish-haskell
    jsonnet
    ocaml
    ocamlPackages.merlin
    ocamlPackages.ocamlbuild
    ocamlPackages.ocp-indent
    ocamlPackages.utop
    ocamlformat
    nixfmt
    nodejs
    pkg-config
    protobuf
    pyPkgs
    python
    rust-analyzer
    rustc
    rustfmt
    tmux
    vim
    wget
    zsh
  ];

  shellHook =
    let templates = import ./templates.nix { inherit pkgs zsh pname; };
    in ''
      source ${templates.dev-shell}
    '';
}

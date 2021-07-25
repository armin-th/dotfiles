{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  python = python3;
  pyPkgs = (python.withPackages (p: with p; [
    flake8
    python-language-server
    pyls-black
    pyls-isort
    pyls-mypy
  ]));
in

pkgs.stdenv.mkDerivation rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    cargo
    curl
    editorconfig-core-c
    emacs-nox
    git
    nodejs
    pkg-config
    pyPkgs
    python
    rust-analyzer
    rustc
    tmux
    vim
    wget
    zsh
  ];

  shellHook =
    let
      templates = import ./templates.nix { inherit pkgs zsh pname; };
    in ''
      source ${templates.dev-shell}
    '';
}


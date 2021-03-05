{ pkgs ? import <nixpkgs> {} }:

with pkgs;

pkgs.stdenv.mkDerivation rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    cargo
    curl
    emacs-nox
    git
    nodejs
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


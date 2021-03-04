{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  templates = import ./templates.nix { inherit pkgs zsh; };
in

pkgs.stdenv.mkDerivation rec {
  pname = "dev-tools";
  version = "1.0.0";

  buildInputs = [
    cargo
    emacs-nox
    git
    nodejs
    rustc
    tmux
    zsh
  ];

  shellHook = ''
    tmux -f ${templates.tmux-conf} new-session -A -s ${pname} "ZDOTDIR=${templates.z-dot-dir} zsh -i"
  '';
}

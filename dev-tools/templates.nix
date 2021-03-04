{ pkgs, zsh }:

with pkgs;

{
  z-dot-dir = writeTextFile {
    name = "zsh-dot-dir";
    destination = "/.zshrc";
    text = ''
      source $HOME/.zshrc

      export NPM_GLOBAL=$HOME/.npm-global

      npm config set prefix $NPM_GLOBAL

      export PATH=$NPM_GLOBAL/bin:$PATH

      alias ec=emacs

      export EDITOR=emacs
    '';
  };

  tmux-conf = writeTextFile {
    name="tmux.conf";
    text = ''
      source-file $HOME/.tmux.conf

      set -g default-command ${zsh.outPath}/bin/zsh
    '';
  };
}


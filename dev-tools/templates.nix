{ pkgs, zsh, pname }:

with pkgs;

let
  dev-shell-utils-body = ''
    if [ "$1" = "ls" ]; then
      tmux ls
      return
    fi

    if [ "$1" = "rm" ]; then
      tmux kill-session -t $2
      return
    fi
  '';
in

rec {
  z-dot-dir = writeTextFile {
    name = "zsh-dot-dir";
    destination = "/.zshrc";
    text = ''
      export NIX_DEV_TOOLS_SHELL=1

      source ${dev-shell-utils}

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

  dev-shell = writeTextFile {
    name = "dev-shell";
    text = ''
      function dev-shell() {
        ${dev-shell-utils-body}

        if [ -z $1 ]; then
          SESSION_NAME=${pname}
        else
          SESSION_NAME=$1
        fi

        tmux -u -f ${tmux-conf} new-session -A -s $SESSION_NAME "ZDOTDIR=${z-dot-dir} zsh -i"
      }
    '';
  };

  dev-shell-utils = writeTextFile {
    name = "dev-shell-utils";
    text = ''
      function dev-shell-utils() {
        ${dev-shell-utils-body}
      }
    '';
  };
}


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

      export BASE_PATH=$PATH

      export PATH=$NPM_GLOBAL/bin:$BASE_PATH

      npm config set prefix $NPM_GLOBAL

      if ! type bash-language-server > /dev/null; then
        npm i -g bash-language-server@latest
      fi

      NPM_BIN_PATH=$NPM_GLOBAL/bin/npm
      if [ ! -e "$NPM_BIN_PATH" ]; then
        npm i -g npm@latest
      fi

      export PATH=$NPM_GLOBAL/bin:$BASE_PATH

      alias ec=emacs

      export EDITOR=emacs

      export GIT_EDITOR=vim
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
          SESSION_NAME=dev
        else
          SESSION_NAME=$1
        fi

        export ZDOTDIR=${z-dot-dir}

        tmux -u -f ${tmux-conf} new-session -A -s $SESSION_NAME "zsh -i"
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


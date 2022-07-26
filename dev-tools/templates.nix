{ pkgs, sbcl, zsh, defaultSessionName ? "dev" }:

rec {
  z-dot-dir = pkgs.writeTextFile {
    name = "zsh-dot-dir";
    destination = "/.zshrc";
    text = ''
      export NIX_DEV_TOOLS_SHELL=1

      source $HOME/.zshrc

      export NPM_GLOBAL=$HOME/.npm-global

      export SBCL_HOME=${sbcl.outPath}/lib/sbcl

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

      alias nxd="nix develop --command 'NIX_ZSH_SHELL=1 zsh'"
      alias ec="emacs"
      alias nec="nix develop --command emacs"

      export EDITOR=emacs

      export GIT_EDITOR=vim
    '';
  };

  tmux-conf = pkgs.writeTextFile {
    name="tmux.conf";
    text = ''
      source-file $HOME/.tmux.conf

      set -g default-command ${zsh.outPath}/bin/zsh
    '';
  };

  dev-shell = pkgs.writeTextFile rec {
    name = "dev-shell";
    executable = true;
    destination = "/bin/${name}";
    text = ''
      if [ "$1" = "ls" ]; then
        tmux ls
        exit 0
      fi

      if [ "$1" = "rm" ]; then
        tmux kill-session -t $2
        exit 0
      fi

      if [ "$NIX_DEV_TOOLS_SHELL" = "1" ]; then
        exit 0
      fi

      if [ -z $1 ]; then
        SESSION_NAME=${defaultSessionName}
      else
        SESSION_NAME=$1
      fi

      tmux -u -f ${tmux-conf} new-session -A -s $SESSION_NAME "ZDOTDIR=${z-dot-dir} zsh -i"
    '';
  };
}


if [ -z $(which curl) ]; then
  echo "Please install curl on this system to continue."
  exit 1
fi

if [ -z $(which nix-shell) ]; then
  echo
  echo "Warning: You will need the nix package manager for some utilities."
  echo "See https://nixos.org/guides/install-nix"
  echo
fi

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P  )"

if [ ! -d $HOME/.oh-my-zsh ]; then
  echo "installing ohmyzsh"
  nix-shell $SCRIPT_PATH/dev-tools --command 'RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi

echo "copying dev-tools derivation to home directory"
rm -rf $HOME/.dev-tools
cp -r $SCRIPT_PATH/dev-tools $HOME/.dev-tools


echo "copying config files to home directory"
cp $SCRIPT_PATH/zshrc $HOME/.zshrc
cp $SCRIPT_PATH/bashrc $HOME/.bashrc
cp $SCRIPT_PATH/spacemacs $HOME/.spacemacs
cp $SCRIPT_PATH/tmux.conf $HOME/.tmux.conf
cp $SCRIPT_PATH/vimrc $HOME/.vimrc

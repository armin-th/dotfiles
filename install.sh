if [ -z $(which curl) ] || [ -z $(which gunzip) ]; then
  echo "Please install curl and gunzip on this system to continue."
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
  nix develop $SCRIPT_PATH/dev-tools --command curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
fi

if [ ! -d $HOME/.emacs.d ]; then
  echo "installing spacemacs"
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

if [ ! -d $HOME/.tmux/plugins/tpm ]; then
  echo "installing Tmux Plugin Management"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -e $HOME/.local/bin/xdg-open ] && [ ! -z $WSLENV ]; then
  echo "installing wsl-open"
  cp $SCRIPT_PATH/wsl-open/wsl-open $HOME/.local/bin/xdg-open # See https://github.com/4U6U57/wsl-open
  chmod u+x $HOME/.local/bin/xdg-open
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
mkdir -p $HOME/.config/nvim
cp $SCRIPT_PATH/nvim-config.lua $HOME/.config/nvim/init.lua

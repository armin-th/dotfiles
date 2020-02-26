if !isdirectory($HOME . '/.vim/.undo/')
  call mkdir($HOME . '/.vim/.undo/', 'p')
endif
set undodir=$HOME/.vim/.undo//
set undofile

if !isdirectory($HOME . '/.vim/.backup/')
  call mkdir($HOME . '/.vim/.backup/', 'p')
endif
set backupdir=$HOME/.vim/.backup//
set backup

if !isdirectory($HOME . '/.vim/.swp/')
  call mkdir($HOME . '/.vim/.swp/', 'p')
endif
set directory=$HOME/.vim/.swp//

map <C-n> :NERDTreeToggle<CR>
map ,m :NERDTreeFind<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

set tabstop=2
set shiftwidth=2
set expandtab

set number
set ruler

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


" Make sure you use single quotes
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ajh17/VimCompletesMe'
Plug 'elixir-lang/vim-elixir'
Plug 'jiangmiao/auto-pairs'
Plug 'kien/ctrlp.vim'
Plug 'leafgarland/typescript-vim'
Plug 'lnl7/vim-nix'
Plug 'morhetz/gruvbox'
Plug 'mxw/vim-jsx'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'yggdroot/indentline'


call plug#end()

let g:deoplete#enable_at_startup = 1

let g:javascript_plugin_flow = 1

let g:ale_linters = {
\   'javascript': ['eslint', 'tslint'],
\   'rust': ['rls'],
\   'java': [],
\}

let g:ale_fixers = {
\   'python': ['autopep8'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'elixir': ['mix_format'],
\   'rust': ['rustfmt'],
\   'java': [],
\}

let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
let g:ctrlp_custom_ignore = 'node_modules'

set t_ut=
set t_Co=256

set background=dark

try
  colorscheme gruvbox
catch 
endtry

highlight Visual cterm=NONE ctermfg=NONE

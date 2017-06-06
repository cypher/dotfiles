" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen (http://www.vim.org/scripts/script.php?script_id=2332) for
" easier bundle management
call pathogen#infect()

source $HOME/.vim/basics.vim
source $HOME/.vim/bindings.vim
source $HOME/.vim/editing.vim
source $HOME/.vim/window.vim
source $HOME/.config/nvim/extensions.vim
" source $HOME/.config/nvim/snippets.vim
" Load nvim-specific stuff
source $HOME/.config/nvim/nvim.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load local config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable($HOME . "/.nvimrc.local")
  source ~/.nvimrc.local
endif

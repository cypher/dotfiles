set lines=50 columns=150
" colorscheme vividchalk
colorscheme xoria256

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set gfn=Monaco:h10.00
"set gfn=Inconsolata:h13.00
set gfn=Anonymous\ Pro:h11.00

set antialias                     " MacVim: smooth fonts.

" Hide the menu bar
set guioptions-=T

set ch=2                     " Make command line two lines high

set mousehide                " Hide the mouse when typing text

" Save all open buffers when MacVim loses focus
au FocusLost * wa

if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-t> <Plug>PeepOpen
end


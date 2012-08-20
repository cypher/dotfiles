set lines=90 columns=230
set background=light
" colorscheme solarized
colorscheme railscat

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set gfn=Meslo\ LG\ S\ DZ:h10.00

set antialias                     " MacVim: smooth fonts.

" Hide the menu bar
set guioptions-=T

set ch=2                     " Make command line two lines high

set mousehide                " Hide the mouse when typing text

" Save all open buffers when MacVim loses focus
au FocusLost * wa

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-Shift-A for Ack
  map <D-A> :Ack<space>

  " bind command-] to shift right
  nmap <D-]> >>
  vmap <D-]> >>
  imap <D-]> <C-O>>>

  " bind command-[ to shift left
  nmap <D-[> <<
  vmap <D-[> <<
  imap <D-[> <C-O><<

  " open tabs with command-<tab number>
  map <D-S-]> gt
  map <D-S-[> gT
  map <D-1> 1gt
  map <D-2> 2gt
  map <D-3> 3gt
  map <D-4> 4gt
  map <D-5> 5gt
  map <D-6> 6gt
  map <D-7> 7gt
  map <D-8> 8gt
  map <D-9> 9gt
  map <D-0> :tablast<CR>

  " Enable default OS X shift-movement/replacement behavior
  let macvim_hig_shift_movement = 1

  macmenu &File.New\ Tab key=<nop>
  map <D-t> <Plug>PeepOpen

  " Activate spelling support, via https://twitter.com/b4winckler/status/58584667200303104
  " Enables Cmd-; and Cmd-:
  set spell

  set macmeta
end


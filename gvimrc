set lines=90 columns=230

set background=light

" colorscheme solarized
" colorscheme railscat
" colorscheme github

set guioptions-=T           " Hide the menu bar
set guioptions+=c           " Use console dialgs

set cmdheight=2             " Make command line two lines high

set mousehide               " Hide the mouse when typing text


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set gfn=Meslo\ LG\ S\ DZ:h10.00

set antialias               " MacVim: smooth fonts.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MacVim Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_macvim")
    " Save all open buffers when MacVim loses focus
    au FocusLost * wa

    " Fullscreen takes up entire screen
    set fuoptions=maxhorz,maxvert
    
    " bind command-] to shift right
    nmap <D-]> >>
    vmap <D-]> >>
    imap <D-]> <C-O>>>
    
    " bind command-[ to shift left
    nmap <D-[> <<
    vmap <D-[> <<
    imap <D-[> <C-O><<
    
    "custom tab stuff
    " tab navigation like safari
    " idea adopted from: [[VimTip1221]]
    nmap <D-[> :tabprevious<CR>
    nmap <D-]> :tabnext<CR>
    map  <D-[> :tabprevious<CR>
    map  <D-]> :tabnext<CR>
    imap <D-[> <Esc>:tabprevious<CR>i
    imap <D-]> <Esc>:tabnext<CR>i
    nmap <D-t> :tabnew<CR>
    imap <D-t> <Esc>:tabnew<CR>
    
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
    " let macvim_hig_shift_movement = 1
    
    " Activate spelling support, via https://twitter.com/b4winckler/status/58584667200303104
    " Enables Cmd-; and Cmd-:
    set spell
    
    set macmeta
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable($HOME . "/.gvimrc.local")
  source ~/.gvimrc.local
endif
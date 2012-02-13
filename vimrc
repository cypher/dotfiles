" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen (http://www.vim.org/scripts/script.php?script_id=2332) for
" easier bundle management
call pathogen#infect()

" Make , the personal leader key
let mapleader = ","
let maplocalleader = ","

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Make ' more useful, swap it with `
nnoremap ' `
nnoremap ` '

set backup                    " keep a backup file
set hidden                    " Allow Vim to manage hidden buffers effectively
set history=500               " keep 500 lines of command line history
set ruler                     " show the cursor position all the time
set showcmd                   " display incomplete commands
set incsearch                 " do incremental searching
set number                    " show line numbers

runtime macros/matchit.vim    " Enable extended % matching

filetype on                   " detect the type of file
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins

set cf                        " enable error files and error jumping
set ffs=unix,dos,mac          " support all three, in this order
set viminfo+=!                " make sure it can save viminfo
set isk+=_,$,@,%,#,-          " none of these should be word dividers, so make them not be
set title                     " show title in xterm

" Make completion useful
set wildmenu

" Ignore these files when completing names and in Explorer
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" Specify which keys can move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in that
" line
" set whichwrap+=<,>,[,]

" make /-style searches case-sensitive only if there is a capital letter in the search expression
set ignorecase
set smartcase

" automatically insert a \v before any search string, so search uses
" normal regexes
nnoremap / /\v
vnoremap / /\v

set gdefault                  " always apply substitutions globally on a line

" Clear out any search by typing <leader><space>
nnoremap <leader><space> :noh<cr>

" Sane searching
set hlsearch                  " Hilight search term
set showmatch                 " Show matching brackets
set incsearch                 " ... dynamically as they are typed
" turn of hlsearch temporarily
nmap <silent> <leader>n :silent :nohlsearch<CR>

" This line will make Vim set out tab characters, trailing whitespace and
" invisible spaces visually, and additionally use the # sign at the end of
" lines to mark lines that extend off-screen. For more info, see :h listchars.
set list
set listchars=tab:▸\ ,eol:¬,trail:.,extends:#,nbsp:.

" Make trailing whitespace visible with ,s
nmap <silent> <leader>s :set nolist!<CR>

set scrolloff=3               " Start scrolling 3 lines before the border

set autoread                  " Automatically reread files that have been changed externally

if v:version >= 720
  set relativenumber            " show how far away each line is from the current one
endif
" set undofile                  " save undo information

" Make ^e and ^y scroll 3 lines instead of 1
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Switch to alternate file
nnoremap <leader><leader> <c-^>

" shorten command-line text and other info tokens (see :help shortmess)
set shortmess=atI

" Only use one space after ., ? or ! with a join command
set nojoinspaces

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Make j and k behave more natural when working with long, wrapped lines
nnoremap j gj
nnoremap k gk

" Make the tab key match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" Make ';' an alias for ':'
nnoremap ; :

" Useful trick when I've forgotten to `sudo' before editing a file:
cmap w!! w !sudo tee % >/dev/null

" Automagically save files when focus is lost, but ignore any warnings, e.g.
" when a buffer doesn't have an associated file
autocmd BufLeave,FocusLost silent! wall

" ,W strips all trailing whitespace from current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
" map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>t :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>

" allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

" don't move the cursor after pasting
" (by jumping to back start of previously changed text)
noremap p p`[
noremap P P`[

" status line
set statusline=
set statusline+=%f\ %2*%m\ %1*%h
set statusline+=%#warningmsg#
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}]\ %12.(%c:%l/%L%)
set laststatus=2

" tag support
set tags=./tags;

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark          " we are using a dark background
syntax on                    " syntax highlighting on
filetype plugin indent on

colorscheme asmdev

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files/Backups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set backup                  " make backup file
" where to put backup file
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" directory is the directory for temp file
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set makeef=error.err         " When using make, where should it dump the file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fo=tcrqn                 " See Help (complex)
set autoindent               " autoindent
set nosmartindent            " smartindent
set cindent                  " do c-style indenting
"set tabstop=2               " tab spacing (settings below are just to unify it)
set softtabstop=2            " unify
set shiftwidth=2             " unify
set expandtab                " use spaces instead of tabs
"set nowrap                  " do not wrap lines
set smarttab                 " use tabs at the start of a line, spaces elsewhere

" Highlight trailing whitespace
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
match WhitespaceEOL /\s\+$/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"    Enable folding, but by default make it act like folding is off, because folding is
"    annoying in anything but a few rare cases
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable               " Turn on folding
"set foldmethod=indent       " Make folding indent sensitive
set foldmethod=marker        " 
set foldlevel=100            " Don't autofold anything (but I can still fold manually)
"set foldopen-=search        " don't open folds when you search into them
"set foldopen-=undo          " don't open folds when you undo stuff

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Encoding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set encoding="utf8"         " We always want utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Instead of having to press 'ctrl-w h' to move to the window to the left, just press ctrl-h,
" etc.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCompletion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" " Enable OmniCompletion for Ruby
autocmd FileType ruby set omnifunc=rubycomplete#Complete
" " ... and Rails
" autocmd FileType ruby let g:rubycomplete_rails = 1
" " ... and to include Classes in global completions
" autocmd FileType ruby let g:rubycomplete_classes_in_global = 1

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-commentary settings
autocmd FileType sql set commentstring=--\ %s
autocmd FileType vim set commentstring=\"\ %s

" Python should always use 4-space indent
au FileType python setl ai ts=4 sts=4 et sw=4

" .inc files are Django templates
au BufRead,BufNewFile {*.inc} set ft=htmldjango

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} set ft=ruby

" Syntax highlight shell scripts as per POSIX,
" not the original Bourne shell which very few use
let g:is_posix = 1

" bind control-l to hashrocket
imap <C-l> <Space>=><Space>

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Flake8
autocmd BufWritePost *.py call Flake8()

" Nicked from Gary Bernhardt's vimrc
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction

function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    " XXX: How do I copy into a variable so I don't pollute the registers?
    :normal "ayiw
    " It takes 4 diws to get the variable, equal sign, and surrounding
    " whitespace. I'm not sure why. diw is different from dw in this respect.
    :normal 4diw
    " Delete the expression into the 'b' register
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . @b
endfunction

vnoremap <leader>rv :call ExtractVariable()<cr>
nnoremap <leader>ri :call InlineVariable()<cr>

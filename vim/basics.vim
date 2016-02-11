" Set default encoding to UTF-8.
set encoding=utf-8 fileencodings=

" Make ',' the personal leader key
let mapleader = ","
let maplocalleader = ","

" Make ' more useful, swap it with `
nnoremap ' `
nnoremap ` '


set backspace=indent,eol,start  " Backspace deletes like most programs in insert mode
set nobackup                    " Don't keep a backup file
set writebackup                 " … but do keep a backup file during writes
set directory-=.                " Don't store swapfiles in the current directory
set makeef=error.err            " When using make, where should it dump the file
set hidden                      " Allow Vim to manage hidden buffers effectively
set history=500                 " Keep 500 lines of command line history
set ruler                       " Show the cursor position all the time
set showcmd                     " Display incomplete commands
set incsearch                   " Do incremental searching
set ruler                       " Show the cursor position all the time
set number                      " Show line numbers
set numberwidth=5               " How many columns to use for the line number
set autowrite                   " Automatically :write before running commands
set laststatus=2                " Always display the status line
set tildeop                     " Make ~ work like a normal operator
set gdefault                    " always apply substitutions globally on a line
set fileformats=unix,dos,mac    " support all three, in this order
set viminfo+=!                  " make sure it can save viminfo
set iskeyword+=_,$,@,%,#,-      " none of these should be word dividers, so make them not be
set title                       " show title in xterm
set scrolloff=3                 " Start scrolling 3 lines before the border
set autoread                    " Automatically reread files that have been changed externally
set shortmess=atI               " shorten command-line text and other info tokens (see :help shortmess)
set winwidth=80                 " Make sure the current split has at least 80 width
set nojoinspaces                " Only use one space after ., ? or ! with a join command
set clipboard=unnamed           " Yank and paste with the system clipboard
set ttyfast                     " We have a fast terminal

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" Sane searching
set hlsearch                    " Hilight search term
set showmatch                   " Show matching brackets
set incsearch                   " ... dynamically as they are typed


" runtime macros/matchit.vim    " Enable extended % matching


" Syntax highlighting and stuff
syntax on
filetype on                     " detect the type of file
filetype indent on              " Enable filetype-specific indenting
filetype plugin on              " Enable filetype-specific plugins


set wildmenu                    " Make completion useful: show a navigable menu for tab completion
set wildignore+=.svn,CVS,.git,*.pyc,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*/tmp/*,*.zip,log/**,node_modules/**,target/**,tmp/**,*.rbc    " Ignore these files when completing names and in Explorer
set wildmode=list:longest,list:full  " List all matches and complete till longest common string, or complete first match
set complete=.,b,u,]            " Pull from keywords for completion in the current file, other buffers (closed or still open), and from the current tags file.
set suffixes+=.old              " set of file name suffixes that will be given a lower priority when it comes to matching wildcards


" Set spellfile to location that is guaranteed to exist,
" can be symlinked to Dropbox or kept in Git
" and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell


" This line will make Vim set out tab characters, trailing whitespace and
" invisible spaces visually, and additionally use the # sign at the end of
" lines to mark lines that extend off-screen. For more info, see :h listchars.
set listchars=extends:»,precedes:«,trail:•,tab:▸\ ,eol:¶,nbsp:▫
set listchars=extends:»,precedes:«,trail:▫,tab:▸\ ,eol:¬,nbsp:•
set list


" Specify which keys can move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in that
" line
" set whichwrap+=<,>,[,]


" make /-style searches case-sensitive only if there is a capital letter in the search expression
set ignorecase
set smartcase


" save undo information
set undodir=$HOME/.vim-undo
set undofile
set undolevels=1000
set undoreload=10000


" status line
set statusline=
set statusline+=%f\ %2*%m\ %1*%h
set statusline+=%#warningmsg#
set statusline+=%{fugitive#statusline()}
set statusline+=%*
set statusline+=%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}]\ %12.(%c:%l/%L%)


" tag support
set tags=./tags;

" file for autosaved session
let g:ausession=".vimsession"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set formatoptions=tcrqnj        " See Help (complex)
set autoindent                  " autoindent
set nosmartindent               " No smartindent, because…
set cindent                     " C-style indenting is better

set tabstop=4                   " tab spacing (settings below are just to unify it)
set softtabstop=4               " unify
set shiftwidth=4                " unify
set expandtab                   " use spaces instead of tabs
set smarttab                    " use tabs at the start of a line, spaces elsewhere


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set t_Co=256                    " 256 colors
set background=dark             " we are using a dark background

" colorscheme asmdev
" colorscheme github
" colorscheme jellybeans
colorscheme smyck

" Highlight trailing whitespace
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0
match WhitespaceEOL /\s\+\%#\@<!$/


highlight ColorColumn ctermbg=magenta
" '\%81v' is a regex matching the virtual 81st column
call matchadd('ColorColumn', '\%121v', 100)


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

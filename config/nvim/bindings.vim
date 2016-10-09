""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make ';' an alias for ':'
nnoremap ; :


" Map `kj` to ESC
imap kj <ESC>


" Map shift-K to Noop, since I keep hitting it accidentally, and I don't need it
map <S-k> <Nop>


" automatically insert a \v before any search string, so search uses normal regexes
nnoremap / /\v
vnoremap / /\v


" Clear search buffer
" nnoremap <leader><leader> :nohlsearch<CR>
nnoremap <leader>l :nohlsearch<CR>


" Make trailing whitespace visible with ,s
nmap <silent> <leader>s :set nolist!<CR>


" Make ^e and ^y scroll 5 lines instead of 1
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>


" Switch to alternate file
nnoremap <leader>. <c-^>


" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


" Make j and k behave more natural when working with long, wrapped lines
nnoremap j gj
nnoremap k gk


" Make the tab key match bracket pairs
nnoremap <tab> %
vnoremap <tab> %


" Useful trick when I've forgotten to `sudo' before editing a file:
cmap w!! w !sudo tee % >/dev/null


" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <leader>e
" map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>


" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <leader>t
" map <leader>t :tabe <C-R>=expand("%:p:h") . "/" <CR>


" Shift-tab to insert a hard tab
" imap <silent> <S-tab> <C-v><tab>


" don't move the cursor after pasting
" (by jumping to back start of previously changed text)
noremap p p`[
noremap P P`[


" Swap v and CTRL-V, because Block mode is more useful that Visual mode
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v


" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv


" Make Y behave like other capitals
map Y y$


" bind Ctrl-l to hashrocket
imap <C-l> <Space>=><Space>


" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>
" map <leader>rt :!ctags --extra=+f -R .<CR><CR>


" Switch between the last two files
" nnoremap <leader><leader> <c-^>


" Easy reloading of vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>


" spec just a method/group
" map <leader>s :!bundle exec spec <C-R>=expand("%:p")<CR> --format nested -c -l <C-R>=line(".")<CR><CR>
" spec entire file
" map <leader>S :!bundle exec spec <C-r>=expand("%:p")<CR> --format nested -c<CR>


" Map <leader>ts2 to expand (t)abs to (s)paces with (2) characters indicating a tab
nnoremap <leader>ts2 :set tabstop=2 softtabstop=2 shiftwidth=2 expandtab<CR>

" Map <leader>ts4 to expand (t)abs to (s)paces with (4) characters indicating a tab
nnoremap <leader>ts4 :set tabstop=4 softtabstop=4 shiftwidth=4 expandtab<CR>

" Map <leader>tt2 to (t)abs to be treated as (t)ab characters and display as (2) characters
nnoremap <leader>tt2 :set tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab<CR>

" Map <leader>tt4 to (t)abs to be treated as (t)ab characters and display as (4) characters
nnoremap <leader>tt4 :set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab<CR>


" Adjust viewports to the same size
noremap <leader>= <C-w>=


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Automagically save files when focus is lost, but ignore any warnings, e.g.
" when a buffer doesn't have an associated file
autocmd BufLeave,FocusLost silent! wall


augroup vimrcEx
  autocmd!

  " Inspired by Gary Bernhardt/Destroy All Software
  " Jump to last cursor position unless it's invalid or in an event handler
  " when reopening a file/vim
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set autoindent shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python set shiftwidth=4 softtabstop=4 expandtab
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <Left>  :echoe "Use h!"<CR>
map <Right> :echoe "Use l!"<CR>
map <Up>    :echoe "Use k!"<CR>
map <Down>  :echoe "Use j!"<CR>

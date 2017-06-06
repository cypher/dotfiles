""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FileType specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Some languages should always use 4-space indent
autocmd FileType python setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType sql setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType html setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType htmldjango setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType rust setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType swift setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType c setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType go setlocal autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab


" Handy for running go tests
" autocmd FileType go map <leader>t :w<CR> :set makeprg=go\ test<CR> :make<CR>


" .inc files are Django templates
autocmd BufRead,BufNewFile {*.inc} set filetype=jinja


" Thorfile, Rakefile and Gemfile are Ruby
autocmd BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru} setlocal filetype=ruby


" Customize markdown file settings
autocmd FileType *.md set wrap|set linebreak|set nolist
autocmd FileType *.markdown set wrap|set linebreak|set nolist
autocmd BufRead,BufNewFile *.md set filetype=markdown

" Spell-check Markdown files
autocmd FileType markdown setlocal spell

" Git Commit
" (Spell check, max line length of 72)
autocmd Filetype gitcommit setlocal spell textwidth=72


" Always turn on syntax highlighting for diffs
augroup PatchDiffHighlight
    autocmd!
    autocmd FileType  diff   syntax enable
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Configure netrw
let g:netrw_banner=0        " disable annoying banner
let g:netrw_liststyle=3     " tree view
let g:netrw_browse_split=4  " open in previous window (1 = new horz split, 2 = new vertical split, 3 = new tab, 4 = prev window)
let g:netrw_altv=1          " open splits to the right
let g:netrw_winsize=15      " Make it look like a file drawer (25% width of window)
let g:netrw_list_hide = &wildignore " Reuse wildignore for hiding files
" Launch netrw right after opening vim
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END


" " rainbow parentheses
au VimEnter * RainbowParentheses
" let g:rainbow#max_level = 16
" let g:rainbow#pairs = [['(', ')'], ['[', ']']]
" List of colors that you do not want. ANSI code or #RRGGBB
" let g:rainbow#blacklist = [233, 234]


" vim-commentary settings
autocmd FileType sql set commentstring=--\ %s
autocmd FileType vim set commentstring=\"\ %s


" tasklist plugin
map <leader>v <Plug>TaskList


" Syntax highlight shell scripts as per POSIX,
" not the original Bourne shell which very few use
let g:is_posix = 1


" Don't conceal things like "->" with their Unicode representation
let g:no_rust_conceal = 1


" Strip trailing whitespace - The Plugin
nmap <leader><space> :call whitespace#strip_trailing()<CR>


" Snippets are activated by Shift+Tab
" let g:snippetsEmu_key = "<S-Tab>"


" Tabularize
" nmap <leader>a= :Tabularize /=<CR>
" vmap <leader>a= :Tabularize /=<CR>
" nmap <leader>a: :Tabularize /:\zs<CR>
" vmap <leader>a: :Tabularize /:\zs<CR>
" nmap <leader>a, :Tabularize /,\zs<CR>
" vmap <leader>a, :Tabularize /,\zs<CR>


" Easy Align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" A.L.E. (Asynchronous Linting Engine)
let g:ale_lint_delay = 1500
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_warning = '⚠️'
let g:ale_sign_error = '❌'
let g:ale_sign_style_warning = '💩'
let g:ale_sign_style_error = '⁉️'


" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'


" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" vim-airline
" Only load the specified extensions
" let g:airline_extensions = ['branch', 'tabline']
" enable/disable automatic population of the `g:airline_symbols` dictionary with powerline symbols.
let g:airline_powerline_fonts = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>m :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>o :CtrlPMixed<CR>
" nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :CtrlPTag<CR>


" Let CtrlP use a cache
let g:ctrlp_use_caching = 1


" Don't keep cache across sessions, because it can lead to
" weird inconsistencies
let g:ctrlp_clear_cache_on_exit = 1


" Custom caching dir
let g:ctrlp_cache_dir = $HOME.'/.ctrlp-cache'


" Up the number of files ctrlp is allowed to scan
let g:ctrlp_max_files = 50000


" Only update after typing has stopped
" let g:ctrlp_lazy_update = 1


if executable('rg')
  set grepprg=rg\ --color=never

  " let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_user_command = {
      \'types': {
        \1: ['.git', 'cd %s && git ls-files . --cached --others --exclude-standard'],
        \2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \},
      \'fallback': 'rg %s --files --color=never --glob ""',
    \}
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = {
      \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --others --exclude-standard'],
        \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \ },
      \ 'fallback': 'ag %s --files-with-matches --nocolor -g ""'
    \ }
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

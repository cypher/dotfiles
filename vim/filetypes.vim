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

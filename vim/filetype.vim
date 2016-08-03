runtime! ftdetect/*.vim

au BufRead,BufNewFile /etc/nginx/* set ft=nginx

au BufRead,BufNewFile *.mustache set ft=mustache

au BufRead,BufNewFile *.es6 set ft=javascript

" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
" (via https://github.com/garybernhardt/dotfiles/commit/99b7d2537ad98dd7a9d3c82b8775f0de1718b356)
au BufRead,BufNewFile *.rb set re=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Snippet-support w/o a plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Read an empty HTML template and move cursor to title
nnoremap <leader>html :-1read $HOME/.vim/snippets/skeleton.html<CR>2jwf>a

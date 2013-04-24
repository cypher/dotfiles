" Vim compiler file
" Language:		Rust
" Maintainer:		n/a
" URL:			n/a

if exists("current_compiler")
  finish
endif
let current_compiler = "rust"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" let s:cpo_save = &cpo
" set cpo-=C

" CompilerSet makeprg=rustc\ $*
CompilerSet makeprg=rust\ run\ $*

" hello.rs:2:4: 2:16 error: unresolved name: io::print_with_unicorns
" hello.rs:2     io::print_with_unicorns("hello?");
"                ^~~~~~~~~~~~~~~~~~~~~~~

CompilerSet errorformat=\%E%f:%l:%c:\ %d:%d\ error:\ %m,
			\%C%f:%l\ %.%#,
			\%Z%p^,
			\%-G%.%#

" let &cpo = s:cpo_save
" unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=8:

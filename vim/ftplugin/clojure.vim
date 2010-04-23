" Vim filetype plugin file
" Language:     Clojure
" Maintainer:   Meikel Brandmeyer <mb@kotka.de>

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal fo< com< cms< cpt< isk< def<"

setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.

setlocal define=^\\s*(def\\(-\\|n\\|n-\\|macro\\|struct\\|multi\\)?

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql
setlocal commentstring=;%s

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:;\ -,mO:;\ \ ,n:;

" Take all directories of the CLOJURE_SOURCE_DIRS environment variable
" and add them to the path option.
if has("win32") || has("win64")
	let s:delim = ";"
else
	let s:delim = ":"
endif
for dir in split($CLOJURE_SOURCE_DIRS, s:delim)
	call vimclojure#AddPathToOption(dir . "/**", 'path')
endfor

" When the matchit plugin is loaded, this makes the % command skip parens and
" braces in comments.
let b:match_words = &matchpairs
let b:match_skip = 's:comment\|string\|character'

" Win32 can filter files in the browse dialog
if has("gui_win32") && !exists("b:browsefilter")
	let b:browsefilter = "Clojure Source Files (*.clj)\t*.clj\n" .
				\ "Jave Source Files (*.java)\t*.java\n" .
				\ "All Files (*.*)\t*.*\n"
endif

for ns in ['clojure.core', 'clojure.set', 'clojure.xml', 'clojure.zip',
			\ 'clojure.walk', 'clojure.template', 'clojure.stacktrace',
			\ 'clojure.inspector', 'clojure.test', 'clojure.test.tap']
	call vimclojure#AddCompletions(ns)
endfor

" Define toplevel folding if desired.
function! ClojureGetFoldingLevel(lineno)
	let closure = { 'lineno' : a:lineno }

	function closure.f() dict
		execute self.lineno

		if vimclojure#SynIdName() =~ 'clojureParen\d' && vimclojure#Yank('l', 'normal! "lyl') == '('
			return 1
		endif

		if searchpairpos('(', '', ')', 'bWr', 'vimclojure#SynIdName() !~ "clojureParen\\d"') != [0, 0]
			return 1
		endif

		return 0
	endfunction

	return vimclojure#WithSavedPosition(closure)
endfunction

" Disabled for now. Too slow (and naive).
if exists("g:clj_want_folding") && g:clj_want_folding == 1 && 0 == 1
	setlocal foldexpr=ClojureGetFoldingLevel(v:lnum)
	setlocal foldmethod=expr
endif

try
	call vimclojure#InitBuffer()
catch /.*/
	" We swallow a failure here. It means most likely that the
	" server is not running.
	echohl WarningMsg
	echomsg v:exception
	echohl None
endtry

call vimclojure#MakePlug("n", "AddToLispWords", 'vimclojure#AddToLispWords(expand("<cword>"))')
call vimclojure#MapPlug("n", "aw", "AddToLispWords")

if exists("b:vimclojure_namespace")
	call vimclojure#MakePlug("n", "DocLookupWord", 'vimclojure#DocLookup(expand("<cword>"))')
	call vimclojure#MakePlug("n", "DocLookupInteractive", 'vimclojure#DocLookup(input("Symbol to look up: "))')
	call vimclojure#MakePlug("n", "JavadocLookupWord", 'vimclojure#JavadocLookup(expand("<cword>"))')
	call vimclojure#MakePlug("n", "JavadocLookupInteractive", 'vimclojure#JavadocLookup(input("Class to lookup: "))')
	call vimclojure#MakePlug("n", "FindDoc", 'vimclojure#FindDoc())')

	call vimclojure#MapPlug("n", "lw", "DocLookupWord")
	call vimclojure#MapPlug("n", "li", "DocLookupInteractive")
	call vimclojure#MapPlug("n", "jw", "JavadocLookupWord")
	call vimclojure#MapPlug("n", "ji", "JavadocLookupInteractive")
	call vimclojure#MapPlug("n", "fd", "FindDoc")

	call vimclojure#MakePlug("n", "MetaLookupWord", 'vimclojure#MetaLookup(expand("<cword>"))')
	call vimclojure#MakePlug("n", "MetaLookupInteractive", 'vimclojure#MetaLookup(input("Symbol to look up: "))')

	call vimclojure#MapPlug("n", "mw", "MetaLookupWord")
	call vimclojure#MapPlug("n", "mi", "MetaLookupInteractive")

	call vimclojure#MakePlug("n", "SourceLookupWord", 'vimclojure#SourceLookup(expand("<cword>"))')
	call vimclojure#MakePlug("n", "SourceLookupInteractive", 'vimclojure#SourceLookup(input("Symbol to look up: "))')

	call vimclojure#MapPlug("n", "sw", "SourceLookupWord")
	call vimclojure#MapPlug("n", "si", "SourceLookupInteractive")

	call vimclojure#MakePlug("n", "GotoSourceWord", 'vimclojure#GotoSource(expand("<cword>"))')
	call vimclojure#MakePlug("n", "GotoSourceInteractive", 'vimclojure#GotoSource(input("Symbol to go to: "))')

	call vimclojure#MapPlug("n", "gw", "GotoSourceWord")
	call vimclojure#MapPlug("n", "gi", "GotoSourceInteractive")

	call vimclojure#MakePlug("n", "RequireFile", 'vimclojure#RequireFile(0)')
	call vimclojure#MakePlug("n", "RequireFileAll", 'vimclojure#RequireFile(1)')

	call vimclojure#MapPlug("n", "rf", "RequireFile")
	call vimclojure#MapPlug("n", "rF", "RequireFileAll")

	call vimclojure#MakePlug("n", "RunTests", 'vimclojure#RunTests(0)')
	call vimclojure#MapPlug("n", "rt", "RunTests")

	call vimclojure#MakePlug("n", "MacroExpand",  'vimclojure#MacroExpand(0)')
	call vimclojure#MakePlug("n", "MacroExpand1", 'vimclojure#MacroExpand(1)')

	call vimclojure#MapPlug("n", "me", "MacroExpand")
	call vimclojure#MapPlug("n", "m1", "MacroExpand1")

	call vimclojure#MakePlug("n", "EvalFile",      'vimclojure#EvalFile()')
	call vimclojure#MakePlug("n", "EvalLine",      'vimclojure#EvalLine()')
	call vimclojure#MakePlug("v", "EvalBlock",     'vimclojure#EvalBlock()')
	call vimclojure#MakePlug("n", "EvalToplevel",  'vimclojure#EvalToplevel()')
	call vimclojure#MakePlug("n", "EvalParagraph", 'vimclojure#EvalParagraph()')

	call vimclojure#MapPlug("n", "ef", "EvalFile")
	call vimclojure#MapPlug("n", "el", "EvalLine")
	call vimclojure#MapPlug("v", "eb", "EvalBlock")
	call vimclojure#MapPlug("n", "et", "EvalToplevel")
	call vimclojure#MapPlug("n", "ep", "EvalParagraph")

	call vimclojure#MakePlug("n", "StartRepl", 'vimclojure#Repl.New()')
	call vimclojure#MapPlug("n", "sr", "StartRepl")

	inoremap <Plug>ClojureReplEnterHook <Esc>:call b:vimclojure_repl.enterHook()<CR>
	inoremap <Plug>ClojureReplUpHistory <C-O>:call b:vimclojure_repl.upHistory()<CR>
	inoremap <Plug>ClojureReplDownHistory <C-O>:call b:vimclojure_repl.downHistory()<CR>

	nnoremap <Plug>ClojureCloseResultBuffer :call vimclojure#ResultBuffer.CloseBuffer()<CR>
	call vimclojure#MapPlug("n", "p", "CloseResultBuffer")

	setlocal omnifunc=vimclojure#OmniCompletion

	augroup VimClojure
		autocmd CursorMovedI <buffer> if pumvisible() == 0 | pclose | endif
	augroup END
endif

let &cpo = s:cpo_save

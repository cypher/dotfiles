" manpageview.vim : extra commands for manual-handling
" Author:	Charles E. Campbell, Jr.
" Date:		Nov 26, 2008
" Version:	22
"
" Please read :help manpageview for usage, options, etc
"
" GetLatestVimScripts: 489 1 :AutoInstall: manpageview.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_manpageview")
 finish
endif
let g:loaded_manpageview = "v22"
if v:version < 702
 echohl WarningMsg
 echo "***warning*** this version of manpageview needs vim 7.2"
 echohl Normal
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
"DechoTabOn

" ---------------------------------------------------------------------
" Set up default manual-window opening option: {{{1
if !exists("g:manpageview_winopen")
 let g:manpageview_winopen= "hsplit"
elseif g:manpageview_winopen == "only" && !has("mksession")
 echomsg "***g:manpageview_winopen<".g:manpageview_winopen."> not supported w/o +mksession"
 let g:manpageview_winopen= "hsplit"
endif

" ---------------------------------------------------------------------
" Sanity Check: {{{1
if !exists("*shellescape")
 fun! manpageview#ManPageView(viamap,bknum,...) range
   echohl ERROR
   echo "You need to upgrade your vim to v7.1 or later (manpageview uses the shellescape() function)"
 endfun
 finish
endif

" ---------------------------------------------------------------------
" Default Variable Values: {{{1
if !exists("g:manpageview_iconv")
 if executable("iconv")
  let s:iconv= "iconv -c"
 else
  let s:iconv= ""
 endif
else
 let s:iconv= g:manpageview_iconv
endif
if s:iconv != ""
 let s:iconv= "| ".s:iconv
endif
if !exists("g:manpageview_pgm")
 let g:manpageview_pgm= "man"
endif
if !exists("g:manpageview_multimanpage")
 let g:manpageview_multimanpage= 1
endif
if !exists("g:manpageview_options")
 let g:manpageview_options= ""
endif
if !exists("g:manpageview_pgm_i")
 let g:manpageview_pgm_i     = "info"
 let g:manpageview_options_i = "--output=-"
 let g:manpageview_syntax_i  = "info"
 let g:manpageview_K_i       = "<sid>ManPageInfo(0)"
 let g:manpageview_init_i    = "call ManPageInfoInit()"

 let s:linkpat1 = '\*[Nn]ote \([^():]*\)\(::\|$\)' " note
 let s:linkpat2 = '^\* [^:]*: \(([^)]*)\)'         " filename
 let s:linkpat3 = '^\* \([^:]*\)::'                " menu
 let s:linkpat4 = '^\* [^:]*:\s*\([^.]*\)\.$'      " index
endif
if !exists("g:manpageview_pgm_pl")
 let g:manpageview_pgm_pl     = "perldoc"
 let g:manpageview_options_pl = ";-f;-q"
endif
if !exists("g:manpageview_pgm_php") && executable("links")
 let g:manpageview_pgm_php     = "links -dump http://www.php.net/"
 let g:manpageview_syntax_php  = "manphp"
 let g:manpageview_nospace_php = 1
 let g:manpageview_K_php       = "<sid>ManPagePhp()"
endif
if exists("g:manpageview_hypertext_tex") && executable("links") && !exists("g:manpageview_pgm_tex")
 let g:manpageview_pgm_tex    = "links ".g:manpageview_hypertext_tex
 let g:manpageview_lookup_tex = "<sid>ManPageTexLookup"
 let g:manpageview_K_tex      = "<sid>ManPageTex()"
endif
if has("win32") && !exists("g:manpageview_rsh")
 let g:manpageview_rsh= "rsh"
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" manpageview#ManPageView: view a manual-page, accepts three formats: {{{2
"    :call manpageview#ManPageView(viamap,"topic")
"    :call manpageview#ManPageView(viamap,booknumber,"topic")
"    :call manpageview#ManPageView(viamap,"topic(booknumber)")
"
"    viamap=0: called via a command
"    viamap=1: called via a map
"    bknum   : if non-zero, then its the book number of the manpage (default=1)
"              if zero, but viamap==1, then use lastline-firstline+1
fun! manpageview#ManPageView(viamap,bknum,...) range
"  call Dfunc("manpageview#ManPageView(viamap=".a:viamap." bknum=".a:bknum.") a:0=".a:0)
  set lz
  let manpageview_fname = expand("%")
  let bknum             = a:bknum
  call s:MPVSaveSettings()

  " fix topic {{{3
  if a:0 > 0
"   call Decho("(fix topic) case a:0 > 0: (a:1<".a:1.">)")
   if &ft != "info"
	if a:0 == 2 && bknum > 0
	 let bknum = bknum.a:1
	 let topic = a:2
	else
     let topic= substitute(a:1,'[^-a-zA-Z.0-9_:].*$','','')
"     call Decho("a:1<".a:1."> topic<".topic."> (after fix)")
	endif
   else
   	let topic= a:1
   endif
   if topic =~ '($'
    let topic= substitute(topic,'($','','')
   endif
"   call Decho("topic<".topic.">  bknum=".bknum." (after fix topic)")
  endif

  if !exists("topic") || topic == ""
   echohl WarningMsg
   echo "***warning*** missing topic"
   echohl None
   sleep 2
"   call Dret("manpageview#ManPageView : missing topic")
   return
  endif

  " interpret the input arguments - set up manpagetopic and manpagebook {{{3
  if a:0 > 0 && strpart(topic,0,1) == '"'
"   call Decho("(interpret input arguments) topic<".topic.">")
   " merge quoted arguments:  Man "some topic here"
"   call Decho('(merge quoted args) case a:0='.a:0." strpart(".topic.",0,1)<".strpart(topic,0,1))
   let manpagetopic = strpart(topic,1)
   if manpagetopic =~ '($'
    let manpagetopic= substitute(manpagetopic,'($','','')
   endif
"   call Decho("manpagetopic<".manpagetopic.">")
   if bknum != ""
   	let manpagebook= string(bknum)
   else
    let manpagebook= ""
   endif
"   call Decho("manpagebook<".manpagebook.">")
   let i= 2
   while i <= a:0
   	let manpagetopic= manpagetopic.' '.a:{i}
	if a:{i} =~ '"$'
	 break
	endif
   	let i= i + 1
   endwhile
   let manpagetopic= strpart(manpagetopic,0,strlen(manpagetopic)-1)
"   call Decho("merged quoted arguments<".manpagetopic.">")

  elseif a:0 == 0
"   call Decho('case a:0==0')
   if exists("g:ManCurPosn") && has("mksession")
"    call Decho("(ManPageView) a:0=".a:0."  g:ManCurPosn exists")
	call s:ManRestorePosn()
   else
    echomsg "***usage*** :Man topic  -or-  :Man topic nmbr"
"    call Decho("(ManPageView) a:0=".a:0."  g:ManCurPosn doesn't exist")
   endif
   call s:MPVRestoreSettings()
"   call Dret("manpageview#ManPageView")
   return

  elseif a:0 == 1
   " ManPageView("topic") -or-  ManPageView("topic(booknumber)")
"   call Decho("case a:0==1 (topic  -or-  topic(booknumber))")
"   call Decho("(ManPageView) a:0=".a:0." topic<".topic.">")
   if a:1 =~ "("
	" abc(3)
"	call Decho("has parenthesis: a:1<".a:1.">  ft<".&ft.">")
	let a1 = substitute(a:1,'[-+*/;,.:]\+$','','e')
"	call Decho("has parenthesis: a:1<".a:1.">  a1<".a1.">")
	if &ft == 'sh'
"	 call Decho('has parenthesis: but ft<'.&ft."> isn't <man>")
	 let manpagetopic = substitute(a:1,'(.*$','','')
	 let manpagebook  = ""
	elseif &ft != 'man'
"	 call Decho('has parenthesis: but ft<'.&ft."> isn't <man>")
	 let manpagetopic = substitute(a:1,'(.*$','','')
	 if a:viamap == 0
      let manpagebook = substitute(a1,'^.*(\([^)]\+\))\=.*$','\1','e')
	 else
	  let manpagebook  = "3"
	 endif
    elseif a1 =~ '[,"]'
"	 call Decho('has parenthesis: a:1 matches [,"]')
     let manpagetopic= substitute(a1,'[(,"].*$','','e')
	else
"	 call Decho('has parenthesis: a:1 does not match [,"]')
     let manpagetopic= substitute(a1,'^\(.*\)(\d\w*),\=.*$','\1','e')
     let manpagebook = substitute(a1,'^.*(\(\d\w*\)),\=.*$','\1','e')
	endif
    if manpagetopic =~ '($'
"	 call Decho('has parenthesis: manpagetopic<'.a:1.'> matches "($"')
     let manpagetopic= substitute(manpagetopic,'($','','')
    endif
    if manpagebook =~ '($'
"	 call Decho('has parenthesis: manpagebook<'.manpagebook.'> matches "($"')
     let manpagebook= ""
    endif

   else
    " ManPageView(booknumber,"topic")
"	call Decho('(ManPageView(booknumber,"topic")) case a:0='.a:0)
    let manpagetopic= topic
    if a:viamap == 1 && a:lastline > a:firstline
     let manpagebook= string(a:lastline - a:firstline + 1)
    elseif a:bknum > 0
     let manpagebook= string(a:bknum)
	else
     let manpagebook= ""
    endif
   endif

  else
   " 3 abc  -or-  abc 3
"   call Decho("(3 abc -or- abc 3) case a:0=".a:0)
   if     topic =~ '^\d\+'
"	call Decho("case topic =~ ^\d\+")
    let manpagebook = topic
    let manpagetopic= a:2
   elseif a:2 =~ '^\d\+$'
"	call Decho("case topic =~ \d\+$")
    let manpagebook = a:2
    let manpagetopic= topic
   elseif topic == "-k"
"	call Decho("case topic == -k")
"    call Decho("user requested man -k")
    let manpagetopic = a:2
    let manpagebook  = "-k"
   elseif bknum != ""
"	call Decho('case bknum != ""')
	let manpagetopic = topic
	let manpagebook  = bknum
   else
	" default: topic book
"	call Decho("default case: topic book")
    let manpagebook = a:2
    let manpagetopic= topic
   endif
  endif
"  call Decho("manpagetopic<".manpagetopic.">")
"  call Decho("manpagebook <".manpagebook.">")

  " for the benefit of associated routines (such as InfoIndexLink()) {{{3
  let s:manpagetopic = manpagetopic
  let s:manpagebook  = manpagebook

  " default program g:manpageview_pgm=="man" may be overridden {{{3
  " if an extension is matched
  if exists("g:manpageview_pgm")
   let pgm = g:manpageview_pgm
  else
   let pgm = ""
  endif
  let ext = ""
  if manpagetopic =~ '\.'
   let ext = substitute(manpagetopic,'^.*\.','','e')
  endif

  " infer the appropriate extension based on the filetype {{{3
  if ext == ""
"   call Decho("attempt to infer on filetype<".&ft.">")

   " filetype: vim
   if &ft == "vim"
   	if g:manpageview_winopen == "only"
	 exe "help ".fnameescape(manpagetopic)
	 only
	elseif g:manpageview_winopen == "vsplit"
	 exe "vert help ".fnameescape(manpagetopic)
	elseif g:manpageview_winopen == "vsplit="
	 exe "vert help ".fnameescape(manpagetopic)
	 wincmd =
	elseif g:manpageview_winopen == "hsplit="
	 exe "help ".fnameescape(manpagetopic)
	 wincmd =
	else
	 exe "help ".fnameescape(manpagetopic)
	endif
"	call Dret("manpageview#ManPageView")
	return

   " filetype: perl
   elseif &ft == "perl"
   	let ext = "pl"

   " filetype:  php
   elseif &ft == "php"
   	let ext = "php"

   " filetype: tex
  elseif &ft == "tex"
   let ext= "tex"
   endif
  endif
"  call Decho("ext<".ext.">")

  " elide extension from manpagetopic {{{3
  if exists("g:manpageview_pgm_{ext}")
   let pgm          = g:manpageview_pgm_{ext}
   let manpagetopic = substitute(manpagetopic,'.'.ext.'$','','')
  endif
  let nospace= exists("g:manpageview_nospace_{ext}")? g:manpageview_nospace_{ext} : 0
"  call Decho("pgm<".pgm."> manpagetopic<".manpagetopic.">")

  " special exception for info {{{3
  if a:viamap == 0 && ext == "i"
   let s:manpageview_pfx_i = "(".manpagetopic.")"
   let manpagetopic        = "Top"
"   call Decho("top-level info: manpagetopic<".manpagetopic.">")
  endif
  if exists("s:manpageview_pfx_{ext}") && s:manpageview_pfx_{ext} != ""
   let manpagetopic= s:manpageview_pfx_{ext}.manpagetopic
  elseif exists("g:manpageview_pfx_{ext}") && g:manpageview_pfx_{ext} != ""
   " prepend any extension-specified prefix to manpagetopic
   let manpagetopic= g:manpageview_pfx_{ext}.manpagetopic
  endif
  if exists("g:manpageview_sfx_{ext}") && g:manpageview_sfx_{ext} != ""
   " append any extension-specified suffix to manpagetopic
   let manpagetopic= manpagetopic.g:manpageview_sfx_{ext}
  endif
  if exists("g:manpageview_K_{ext}") && g:manpageview_K_{ext} != ""
   " override usual K map
"   call Decho("override K map to call ".g:manpageview_K_{ext})
   exe "nmap <silent> K :call ".fnameescape(g:manpageview_K_{ext})."\<cr>"
  endif
  if exists("g:manpageview_syntax_{ext}") && g:manpageview_syntax_{ext} != ""
   " allow special-suffix extensions to optionally control syntax highlighting
   let manpageview_syntax= g:manpageview_syntax_{ext}
  else
   let manpageview_syntax= "man"
  endif

  " support for searching for options from conf pages {{{3
  if manpagebook == "" && manpageview_fname =~ '\.conf$'
   let manpagesrch = '^\s\+'.manpagetopic
   let manpagetopic= manpageview_fname
  endif
"  call Decho("manpagebook<".manpagebook."> manpagetopic<".manpagetopic.">")

  " it was reported to me that some systems change display sizes when a {{{3
  " filtering command is used such as :r! .  I record the height&width
  " here and restore it afterwards.  To make use of it, put
  "   let g:manpageview_dispresize= 1
  " into your <.vimrc>
  let dwidth  = &cwh
  let dheight = &co
"  call Decho("dwidth=".dwidth." dheight=".dheight)

  " Set up the window for the manpage display (only hsplit split etc) {{{3
"  call Decho("set up window for manpage display (g:manpageview_winopen<".g:manpageview_winopen."> ft<".&ft."> manpageview_syntax<".manpageview_syntax.">)")
  if     g:manpageview_winopen == "only"
"   call Decho("only mode")
   silent! windo w
   if !exists("g:ManCurPosn") && has("mksession")
    call s:ManSavePosn()
   endif
   " Record current file/position/screen-position
   if &ft != manpageview_syntax
    silent! only!
   endif
   enew!
  elseif g:manpageview_winopen == "hsplit"
"   call Decho("hsplit mode")
   if &ft != manpageview_syntax
    wincmd s
    enew!
    wincmd _
    3wincmd -
   else
    enew!
   endif
  elseif g:manpageview_winopen == "hsplit="
"   call Decho("hsplit= mode")
   if &ft != manpageview_syntax
    wincmd s
   endif
   enew!
  elseif g:manpageview_winopen == "vsplit"
"   call Decho("vsplit mode")
   if &ft != manpageview_syntax
    wincmd v
    enew!
    wincmd |
    20wincmd <
   else
    enew!
   endif
  elseif g:manpageview_winopen == "vsplit="
"   call Decho("vsplit= mode")
   if &ft != "man"
    wincmd v
   endif
   enew!
  elseif g:manpageview_winopen == "reuse"
"   call Decho("reuse mode")
   " determine if a Manpageview window already exists
   let g:manpageview_manwin= -1
   exe "windo if &ft == '".fnameescape(manpageview_syntax)."'|let g:manpageview_manwin= winnr()|endif"
   if g:manpageview_manwin != -1
	" found a pre-existing Manpageview window, re-using it
	exe fnameescape(g:manpageview_manwin)."wincmd w"
    enew!
   elseif &l:mod == 1
   	" file has been modified, would be lost if we re-used window.  Use hsplit instead.
    wincmd s
    enew!
    wincmd _
    3wincmd -
   elseif &ft != manpageview_syntax
	" re-using current window (but hiding it first)
   	setlocal bh=hide
    enew!
   else
    enew!
   endif
  else
   echohl ErrorMsg
   echo "***sorry*** g:manpageview_winopen<".g:manpageview_winopen."> not supported"
   echohl None
   sleep 2
   call s:MPVRestoreSettings()
"   call Dret("manpageview#ManPageView : manpageview_winopen<".g:manpageview_winopen."> not supported")
   return
  endif

  " add some maps for multiple manpage handling {{{3
  if g:manpageview_multimanpage
   nmap <silent> <script> <buffer> <PageUp>				:call search("^NAME$",'bW')<cr>z<cr>5<c-y>
   nmap <silent> <script> <buffer> <PageDown>			:call search("^NAME$",'W')<cr>z<cr>5<c-y>
  endif

  " allow K to use <cWORD> when in man pages
  if manpageview_syntax == "man"
   nmap <silent> <script> <buffer>	K   :<c-u>call manpageview#ManPageView(1,v:count,expand("<cWORD>"))<CR>
  endif

  " allow user to specify file encoding {{{3
  if exists("g:manpageview_fenc")
   exe "setlocal fenc=".fnameescape(g:manpageview_fenc)
  endif

  " when this buffer is exited it will be wiped out {{{3
  if v:version >= 602
   setlocal bh=wipe
  endif
  let b:did_ftplugin= 2
  let $COLUMNS=winwidth(0)

  " special manpageview buffer maps {{{3
  nnoremap <buffer> <space>     <c-f>
  nnoremap <buffer> <c-]>       :call manpageview#ManPageView(1,expand("<cWORD>"))<cr>

  " -----------------------------------------
  " Invoke the man command to get the manpage {{{3
  " -----------------------------------------

  " the buffer must be modifiable for the manpage to be loaded via :r! {{{4
  setlocal ma

  let cmdmod= ""
  if v:version >= 603
   let cmdmod= "silent keepjumps "
  endif

  " extension-based initialization (expected: buffer-specific maps) {{{4
  if exists("g:manpageview_init_{ext}")
   if !exists("b:manpageview_init_{ext}")
"    call Decho("exe manpageview_init_".ext."<".g:manpageview_init_{ext}.">")
	exe fnameescape(g:manpageview_init_{ext})
	let b:manpageview_init_{ext}= 1
   endif
  elseif ext == ""
   silent! unmap K
   nmap <unique> K <Plug>ManPageView
  endif

  " default program g:manpageview_options (empty string) may be overridden {{{4
  " if an extension is matched
  let opt= g:manpageview_options
  if exists("g:manpageview_options_{ext}")
   let opt= g:manpageview_options_{ext}
  endif
"  call Decho("opt<".opt.">")

  let cnt= 0
  while cnt < 3 && (strlen(opt) > 0 || cnt == 0)
   let cnt   = cnt + 1
   let iopt  = substitute(opt,';.*$','','e')
   let opt   = substitute(opt,'^.\{-};\(.*\)$','\1','e')
"   call Decho("iopt<".iopt."> opt<".opt.">")

   " use pgm to read/find/etc the manpage (but only if pgm is not the empty string)
   " by default, pgm is "man"
   if pgm != ""

	" ---------------------------
	" use manpage_lookup function {{{4
	" ---------------------------
   	if exists("g:manpageview_lookup_{ext}")
"	 call Decho("lookup: exe call ".g:manpageview_lookup_{ext}."(".manpagebook.",".manpagetopic.")")
	 exe "call ".fnameescape(g:manpageview_lookup_{ext}."(".manpagebook.",".manpagetopic.")")

    elseif has("win32") && exists("g:manpageview_server") && exists("g:manpageview_user")
"     call Decho("win32: manpagebook<".manpagebook."> topic<".manpagetopic.">")
     exe cmdmod."r!".g:manpageview_rsh." ".g:manpageview_server." -l ".g:manpageview_user." ".pgm." ".iopt." ".shellescape(manpagebook,1)." ".shellescape(manpagetopic,1)
     exe cmdmod.'silent!  %s/.\b//ge'

"   elseif has("conceal")
"    exe cmdmod."r!".pgm." ".iopt." ".shellescape(manpagebook,1)." ".shellescape(manpagetopic,1)

	"--------------------------
	" use pgm to obtain manpage {{{4
	"--------------------------
    else
	 if manpagebook != ""
	  let mpb= shellescape(manpagebook,1)
	 else
	  let mpb= ""
	 endif
     if nospace
"	  call Decho("(nospace) exe silent! ".cmdmod."r!".pgm.iopt.mpb.manpagetopic)
      exe cmdmod."r!".pgm.iopt.mpb.shellescape(manpagetopic,1).s:iconv
     elseif has("win32")
"       call Decho("(win32) exe ".cmdmod."r!".pgm." ".iopt." ".mpb." \"".manpagetopic."\"")
       exe cmdmod."r!".pgm." ".iopt." ".mpb." ".shellescape(manpagetopic,1)." ".s:iconv
	 else
"      call Decho("(nrml) exe ".cmdmod."r!".pgm." ".iopt." ".mpb." '".manpagetopic."'")
      exe cmdmod."r!".pgm." ".iopt." ".mpb." ".shellescape(manpagetopic,1)." ".s:iconv
	endif
     exe cmdmod.'silent!  %s/.\b//ge'
    endif
	setlocal ro nomod noswf
   endif

   " check if manpage actually found {{{3
   if line("$") != 1 || col("$") != 1
"    call Decho("manpage found")
    break
   endif
"   call Decho("manpage not found")
  endwhile

  " here comes the vim display size restoration {{{3
  if exists("g:manpageview_dispresize")
   if g:manpageview_dispresize == 1
"    call Decho("restore display size to ".dheight."x".dwidth)
    exe "let &co=".dwidth
    exe "let &cwh=".dheight
   endif
  endif

  " clean up (ie. remove) any ansi escape sequences {{{3
  silent! %s/\e\[[0-9;]\{-}m//ge
  silent! %s/\%xe2\%x80\%x90/-/ge
  silent! %s/\%xe2\%x88\%x92/-/ge
  silent! %s/\%xe2\%x80\%x99/'/ge
  silent! %s/\%xe2\%x94\%x82/ /ge

  " set up options and put cursor at top-left of manpage {{{3
  if manpagebook == "-k"
   setlocal ft=mankey
  else
   exe cmdmod."setlocal ft=".fnameescape(manpageview_syntax)
  endif
  exe cmdmod."setlocal ro"
  exe cmdmod."setlocal noma"
  exe cmdmod."setlocal nomod"
  exe cmdmod."setlocal nolist"
  exe cmdmod."setlocal nonu"
  exe cmdmod."setlocal fdc=0"
"  exe cmdmod."setlocal isk+=-,.,(,)"
  exe cmdmod."setlocal nowrap"
  set nolz
  exe cmdmod."1"
  exe cmdmod."norm! 0"

  if line("$") == 1 && col("$") == 1
   " looks like there's no help for this topic
   if &ft == manpageview_syntax
	if exists("s:manpageview_curtopic")
	 call manpageview#ManPageView(0,0,s:manpageview_curtopic)
	else
	 q
	endif
   endif
"   call Decho("***warning*** no manpage exists for <".manpagetopic."> book=".manpagebook)
   echohl ErrorMsg
   echo "***warning*** sorry, no manpage exists for <".manpagetopic.">"
   echohl None
   sleep 2
  elseif manpagebook == ""
"   call Decho('exe file '.fnameescape('Manpageview['.manpagetopic.']'))
   exe 'file '.fnameescape('Manpageview['.manpagetopic.']')
   let s:manpageview_curtopic= manpagetopic
  else
"   call Decho('exe file '.fnameescape('Manpageview['.manpagetopic.'('.fnameescape(manpagebook).')]'))
   exe 'file '.fnameescape('Manpageview['.manpagetopic.'('.fnameescape(manpagebook).')]')
   let s:manpageview_curtopic= manpagetopic."(".manpagebook.")"
  endif

  " if there's a search pattern, use it {{{3
  if exists("manpagesrch")
   if search(manpagesrch,'w') != 0
    exe "norm! z\<cr>"
   endif
  endif

  " restore settings {{{3
  call s:MPVRestoreSettings()
"  call Dret("manpageview#ManPageView")
endfun

" ---------------------------------------------------------------------
" s:MPVSaveSettings: save and standardize certain user settings {{{2
fun! s:MPVSaveSettings()

  if !exists("s:sxqkeep")
"   call Dfunc("s:MPVSaveSettings()")
   let s:sxqkeep           = &sxq
   let s:srrkeep           = &srr
   let s:repkeep           = &report
   let s:gdkeep            = &gd
   let s:cwhkeep           = &cwh
   let s:magickeep         = &magic
   setlocal srr=> report=10000 nogd magic
   if &cwh < 2
    " avoid hit-enter prompts
    setlocal cwh=2
   endif
  if has("win32") || has("win95") || has("win64") || has("win16")
   let &sxq= '"'
  else
   let &sxq= ""
  endif
"  call Dret("s:MPVSaveSettings")
 endif

endfun

" ---------------------------------------------------------------------
" s:MPV_RestoreSettings: {{{2
fun! s:MPVRestoreSettings()
  if exists("s:sxqkeep")
"   call Dfunc("s:MPV_RestoreSettings()")
   let &sxq    = s:sxqkeep   | unlet s:sxqkeep
   let &srr    = s:srrkeep   | unlet s:srrkeep
   let &report = s:repkeep   | unlet s:repkeep
   let &gd     = s:gdkeep    | unlet s:gdkeep
   let &cwh    = s:cwhkeep   | unlet s:cwhkeep
   let &magic  = s:magickeep | unlet s:magickeep
"   call Dret("s:MPV_RestoreSettings")
  endif
endfun

" ---------------------------------------------------------------------
" s:ManRestorePosn: restores file/position/screen-position {{{2
"                 (uses g:ManCurPosn)
fun! s:ManRestorePosn()
"  call Dfunc("s:ManRestorePosn()")

  if exists("g:ManCurPosn")
"   call Decho("g:ManCurPosn<".g:ManCurPosn.">")
   if v:version >= 603
	exe 'keepjumps silent! source '.fnameescape(g:ManCurPosn)
   else
	exe 'silent! source '.fnameescape(g:ManCurPosn)
   endif
   unlet g:ManCurPosn
   silent! cunmap q
  endif

"  call Dret("s:ManRestorePosn")
endfun

" ---------------------------------------------------------------------
" s:ManSavePosn: saves current file, line, column, and screen position {{{2
fun! s:ManSavePosn()
"  call Dfunc("s:ManSavePosn()")

  let g:ManCurPosn= tempname()
  let keep_ssop   = &ssop
  let &ssop       = 'winpos,buffers,slash,globals,resize,blank,folds,help,options,winsize'
  if v:version >= 603
   exe 'keepjumps silent! mksession! '.fnameescape(g:ManCurPosn)
  else
   exe 'silent! mksession! '.fnameescape(g:ManCurPosn)
  endif
  let &ssop       = keep_ssop
  cnoremap <silent> q call <SID>ManRestorePosn()<CR>

"  call Dret("s:ManSavePosn")
endfun

let &cpo= s:keepcpo
unlet s:keepcpo

" ---------------------------------------------------------------------
" s:ManPageInfo: {{{2
fun! s:ManPageInfo(type)
"  call Dfunc("s:ManPageInfo(type=".a:type.")")

  if &ft != "info"
   " restore K and do a manpage lookup for word under cursor
"   call Decho("ft!=info: restore K and do a manpage lookup of word under cursor")
   setlocal kp=manpageview#ManPageView
   if exists("s:manpageview_pfx_i")
    unlet s:manpageview_pfx_i
   endif
   call manpageview#ManPageView(1,0,expand("<cWORD>"))
"   call Dret("s:ManPageInfo : restored K")
   return
  endif

  if !exists("s:manpageview_pfx_i")
   let s:manpageview_pfx_i= g:manpageview_pfx_i
  endif

  " -----------
  " Follow Link
  " -----------
  if a:type == 0
   " extract link
   let curline  = getline(".")
"   call Decho("type==0: curline<".curline.">")
   let ipat     = 1
   while ipat <= 4
    let link= matchstr(curline,s:linkpat{ipat})
"	call Decho("..attempting s:linkpat".ipat.":<".s:linkpat{ipat}.">")
    if link != ""
     if ipat == 2
      let s:manpageview_pfx_i = substitute(link,s:linkpat{ipat},'\1','')
      let node                = "Top"
     else
      let node                = substitute(link,s:linkpat{ipat},'\1','')
 	 endif
"   	 call Decho("ipat=".ipat."link<".link."> node<".node."> pfx<".s:manpageview_pfx_i.">")
 	 break
    endif
    let ipat= ipat + 1
   endwhile

  " ---------------
  " Go to next node
  " ---------------
  elseif a:type == 1
"   call Decho("type==1: goto next node")
   let node= matchstr(getline(2),'Next: \zs[^,]\+\ze,')
   let fail= "no next node"

  " -------------------
  " Go to previous node
  " -------------------
  elseif a:type == 2
"   call Decho("type==2: goto previous node")
   let node= matchstr(getline(2),'Prev: \zs[^,]\+\ze,')
   let fail= "no previous node"

  " ----------
  " Go up node
  " ----------
  elseif a:type == 3
"   call Decho("type==3: go up one node")
   let node= matchstr(getline(2),'Up: \zs.\+$')
   let fail= "no up node"
   if node == "(dir)"
	echo "***sorry*** can't go up from this node"
"    call Dret("ManPageInfo : can't go up a node")
    return
   endif

  " --------------
  " Go to top node
  " --------------
  elseif a:type == 4
"   call Decho("type==4: go to top node")
   let node= "Top"
  endif
"  call Decho("node<".(exists("node")? node : '--n/a--').">")

  " use ManPageView() to view selected node
  if !exists("node")
   echohl ErrorMsg
   echo "***sorry*** unable to view selection"
   echohl None
   sleep 2
  elseif node == ""
   echohl ErrorMsg
   echo "***sorry*** ".fail
   echohl None
   sleep 2
  else
   call manpageview#ManPageView(1,0,node.".i")
  endif

"  call Dret("ManPageInfo")
endfun

" ---------------------------------------------------------------------
" s:ManPageInfoInit: {{{2
fun! ManPageInfoInit()
"  call Dfunc("ManPageInfoInit()")

  " some mappings to imitate the default info reader
  nmap    <buffer> 			<cr>	K
  noremap <buffer> <silent>	>		:call <SID>ManPageInfo(1)<cr>
  noremap <buffer> <silent>	n		:call <SID>ManPageInfo(1)<cr>
  noremap <buffer> <silent>	<		:call <SID>ManPageInfo(2)<cr>
  noremap <buffer> <silent>	p		:call <SID>ManPageInfo(2)<cr>
  noremap <buffer> <silent>	u		:call <SID>ManPageInfo(3)<cr>
  noremap <buffer> <silent>	t		:call <SID>ManPageInfo(4)<cr>
  noremap <buffer> <silent>	?		:he manpageview-info<cr>
  noremap <buffer> <silent>	d		:call manpageview#ManPageView(0,0,"dir.i")<cr>
  noremap <buffer> <silent>	<BS>	<C-B>
  noremap <buffer> <silent>	<Del>	<C-B>
  noremap <buffer> <silent>	<Tab>	:call <SID>NextInfoLink()<CR>
  noremap <buffer> <silent>	i		:call <SID>InfoIndexLink('i')<CR>
  noremap <buffer> <silent>	,		:call <SID>InfoIndexLink(',')<CR>
  noremap <buffer> <silent>	;		:call <SID>InfoIndexLink(';')<CR>

"  call Dret("ManPageInfoInit")
endfun

" ---------------------------------------------------------------------
" s:NextInfoLink: {{{2
fun! s:NextInfoLink()
    let ln = search('\('.s:linkpat1.'\|'.s:linkpat2.'\|'.s:linkpat3.'\|'.s:linkpat4.'\)', 'w')
    if ln == 0
		echohl ErrorMsg
	   	echo '***sorry*** no links found' 
	   	echohl None
		sleep 2
    endif
endfun

" ---------------------------------------------------------------------
" s:InfoIndexLink: supports info's "i" for index-search-for-topic {{{2
fun! s:InfoIndexLink(cmd)
"  call Dfunc("s:InfoIndexLink(cmd<".a:cmd.">)")
"  call Decho("indx vars: line #".(exists("s:indxline")? s:indxline : '---'))
"  call Decho("indx vars: cnt  =".(exists("s:indxcnt")? s:indxcnt : '---'))
"  call Decho("indx vars: find =".(exists("s:indxfind")? s:indxfind : '---'))
"  call Decho("indx vars: link <".(exists("s:indxlink")? s:indxlink : '---').">")
"  call Decho("indx vars: where<".(exists("s:wheretopic")? s:wheretopic : '---').">")
"  call Decho("indx vars: srch <".(exists("s:indxsrchdir")? s:indxsrchdir : '---').">")

  " sanity checks
  if !exists("s:manpagetopic")
   echohl Error
   echo "(InfoIndexLink) no manpage topic available!"
   echohl NONE
"   call Dret("s:InfoIndexLink : no manpagetopic")
   return

  elseif !executable("info")
   echohl Error
   echo '(InfoIndexLink) the info command is not executable!'
   echohl NONE
"   call Dret("s:InfoIndexLink : info not exe")
   return
  endif

  if a:cmd == 'i'
   call inputsave()
   let s:infolink= input("Index entry: ","","shellcmd")
   call inputrestore()
   let s:indxfind= -1
  endif
"  call Decho("infolink<".s:infolink.">")

  if s:infolink != ""

   if a:cmd == 'i'
	let mpt= substitute(s:manpagetopic,'\.i','','')
"	call Decho('system("info '.mpt.' --where")')
	let s:wheretopic    = substitute(system("info ".shellescape(mpt)." --where"),'\n','','g')
    let s:indxline      = 1
    let s:indxcnt       = 0
	let s:indxsrchdir   = 'cW'
"	call Decho("new indx vars: cmd<i> where<".s:wheretopic.">")
"	call Decho("new indx vars: cmd<i> line#".s:indxline)
"	call Decho("new indx vars: cmd<i> cnt =".s:indxcnt)
"	call Decho("new indx vars: cmd<i> srch<".s:indxsrchdir.">")
   elseif a:cmd == ','
	let s:indxsrchdir= 'W'
"	call Decho("new indx vars: cmd<,> srch<".s:indxsrchdir.">")
   elseif a:cmd == ';'
	let s:indxsrchdir= 'bW'
"	call Decho("new indx vars: cmd<;> srch<".s:indxsrchdir.">")
   endif

   let cmdmod= ""
   if v:version >= 603
    let cmdmod= "silent keepjumps "
   endif

   let wheretopic= s:wheretopic
   if s:indxcnt != 0
	let wheretopic= substitute(wheretopic,'\.info\%(-\d\+\)\=\.','.info-'.s:indxcnt.".",'')
   else
	let wheretopic= substitute(wheretopic,'\.info\%(-\d\+\)\=\.','.info.','')
   endif
"   call Decho("initial wheretopic<".wheretopic."> indxcnt=".s:indxcnt)

   " search for topic in various files loop
   while filereadable(wheretopic)
"	call Decho("--- while loop: where<".wheretopic."> indxcnt=".s:indxcnt." indxline#".s:indxline)

	" read file <topic.info-#.gz>
    setlocal ma
    silent! %d
	if s:indxcnt != 0
	 let wheretopic= substitute(wheretopic,'\.info\%(-\d\+\)\=\.','.info-'.s:indxcnt.".",'')
	else
	 let wheretopic= substitute(wheretopic,'\.info\%(-\d\+\)\=\.','.info.','')
	endif
"    call Decho("    exe ".cmdmod."r ".fnameescape(wheretopic))
    try
	 exe cmdmod."r ".fnameescape(wheretopic)
	catch /^Vim\%((\a\+)\)\=:E484/
	 break
	finally
	 if search('^File:','W') != 0
	  silent 1,/^File:/-1d
	  1put! =''
	 else
	  1d
	 endif
	endtry
	setlocal noma nomod

	if s:indxline < 0
	 if a:cmd == ','
	  " searching forwards
	  let s:indxline= 1
"	  call Decho("    searching forwards from indxline#".s:indxline)
	 elseif a:cmd == ';'
	  " searching backwards
	  let s:indxline= line("$")
"	  call Decho("    searching backwards from indxline#".s:indxline)
	 endif
	endif

	if s:indxline != 0
"     call Decho("    indxline=".s:indxline." infolink<".s:infolink."> srchflags<".s:indxsrchdir.">")
	 exe fnameescape(s:indxline)
     let s:indxline= search('^\n\zs'.s:infolink.'\>\|^[0-9.]\+.*\zs\<'.s:infolink.'\>',s:indxsrchdir)
"     call Decho("    search(".s:infolink.",".s:indxsrchdir.") yields: s:indxline#".s:indxline)
     if s:indxline != 0
	  let s:indxfind= s:indxcnt
	  echo ",=Next Match  ;=Previous Match"
"      call Dret("s:InfoIndexLink : success!  (indxfind=".s:indxfind.")")
      return
     endif
	endif

	if a:cmd == 'i' || a:cmd == ','
	 let s:indxcnt  = s:indxcnt + 1
	 let s:indxline = 1
	elseif a:cmd == ';'
	 let s:indxcnt  = s:indxcnt - 1
	 if s:indxcnt < 0
	  let s:indxcnt= 0
"	  call Decho("    new indx vars: cmd<".a:cmd."> indxcnt=".s:indxcnt)
	  break
	 endif
	 let s:indxline = -1
	endif
"	call Decho("    new indx vars: cmd<".a:cmd."> indxcnt =".s:indxcnt)
"	call Decho("    new indx vars: cmd<".a:cmd."> indxline#".s:indxline)
   endwhile
  endif
"  call Decho("end-while indx vars: find=".s:indxfind." cnt=".s:indxcnt)

  " clear screen
  setlocal ma
  silent! %d
  setlocal noma nomod

  if s:indxfind < 0
   " unsuccessful :(
   echohl WarningMsg
   echo "(InfoIndexLink) unable to find info for topic<".s:manpagetopic."> indx<".s:infolink.">"
   echohl NONE
"   call Dret("s:InfoIndexLink : unable to find info for ".s:manpagetopic.":".s:infolink)
   return
  elseif a:cmd == ','
   " no more matches
   let s:indxcnt = s:indxcnt - 1
   let s:indxline= 1
   echohl WarningMsg
   echo "(InfoIndexLink) no more matches"
   echohl NONE
"   call Dret("s:InfoIndexLink : no more matches")
   return
  elseif a:cmd == ';'
   " no more matches
   let s:indxcnt = s:indxfind
   let s:indxline= -1
   echohl WarningMsg
   echo "(InfoIndexLink) no previous matches"
   echohl NONE
"   call Dret("s:InfoIndexLink : no previous matches")
   return
  endif
endfun

" ---------------------------------------------------------------------
" s:ManPageTex: {{{2
fun! s:ManPageTex()
  let topic= '\'.expand("<cWORD>")
"  call Dfunc("s:ManPageTex() topic<".topic.">")
  call manpageview#ManPageView(1,0,topic)
"  call Dret("s:ManPageTex")
endfun

" ---------------------------------------------------------------------
" s:ManPageTexLookup: {{{2
fun! s:ManPageTexLookup(book,topic)
"  call Dfunc("s:ManPageTexLookup(book<".a:book."> topic<".a:topic.">)")
"  call Dret("s:ManPageTexLookup ".lookup)
endfun

" ---------------------------------------------------------------------
" s:ManPagePhp: {{{2
fun! s:ManPagePhp()
  let topic=substitute(expand("<cWORD>"),'()\=','.php','')
"  call Dfunc("s:ManPagePhp() topic<".topic.">")
  call manpageview#ManPageView(1,0,topic)
"  call Dret("s:ManPagePhp")
endfun

" ---------------------------------------------------------------------
" Modeline: {{{1
" vim: ts=4 fdm=marker

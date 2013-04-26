" Vim compiler file
" Compiler:     JavaScript Lint (http://www.javascriptlint.com)
" Maintainer:   Ingo Karkat <ingo@karkat.de>
"
" DEPENDENCIES:
"  - jsl (http://www.javascriptlint.com).
"
" CONFIGURATION:
"   The optional jsl configuration must either reside in this script's directory
"   as 'jsl.conf', or its filespec can be specified in g:jsl_config.
"
" USAGE:
"   :make [{jsl-args}]
"
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" REVISION	DATE		REMARKS
"   1.00.003	11-May-2009	Tested on Linux; published version.
"	002	21-Mar-2009	Doing jsl config file detection and filtering of
"				empty error output lines inside the script;
"				removed wrapper script. This compiler plugin now
"				also works on Unix.
"	001	20-Mar-2009	file creation

if exists('current_compiler')
    finish
endif
let current_compiler = 'jsl'

if exists(':CompilerSet') != 2		" older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:scriptDir = expand('<sfile>:p:h')
function! s:JslConfig()
    let l:configFilespec = ''
    if exists('g:jsl_config')
	let l:configFilespec = g:jsl_config
    else
	let l:pathSeparator = (exists('+shellslash') && ! &shellslash ? '\' : '/')
	let l:configFilespec = s:scriptDir . l:pathSeparator . 'jsl.conf'
    endif
    return (! empty(l:configFilespec) && filereadable(l:configFilespec) ? ' -conf "' . l:configFilespec . '"' : '')
endfunction
execute 'CompilerSet makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary' .  escape(s:JslConfig(), ' "\') . '\ $*\ -process\ $*\ \"%\"'
unlet s:scriptDir

" sample output:
"C:\TEMP\jsl\jsl-test.js(9): warning: test for equality (==) mistyped as assignment (=)?
"    if (x = y) {
".............^
"
"C:\TEMP\jsl\jsl-test.js(21): lint warning: missing break statement
"    case 1: z = --x;
"....^
"
"C:\TEMP\jsl\jsl-test.js(20): lint warning: undeclared identifier: z
"C:\TEMP\jsl\jsl-test.js(21): lint warning: undeclared identifier: z

" Errorformat: Cp. |errorformat-javac|
" JavaScript Lint emits an empty line after each "pointer line". If we filter
" this away by having the multiline pattern end with "%-Z" (i.e. match an empty
" line), the error column somehow is counted as a non-virtual column, which is
" wrong. So we let the pattern end with the "pointer line", and filter away the
" empty line in a separate "%-G" pattern.
"CompilerSet errorformat=%A%f(%l):\ %m,%-Z,%-C%p^,%-C%.%#
CompilerSet errorformat=%A%f(%l):\ %m,%-Z%p^,%-C%.%#,%-G

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

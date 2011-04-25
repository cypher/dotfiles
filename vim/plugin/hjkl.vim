
" Use h,j,k,l to bring you('@') to the target('X')
" type q to quit the game
" Maximize window before starting new game to get better view.
" type :HJKL to start new game
" type q to quit game
" type konami code(kkjjhlhlba) several times when you want more challenge
"
" Maintainer:	Bi Ran<biran0079@gmail.com>
"
"
" seed for random number generator
let s:w=localtime()	
let s:z=s:w*22695477
"default difficulty
let s:difficulty=2

function! s:Rand()
	let s:z=36969 * (s:z % 65536) + s:z / 65536
	let s:w=18000 * (s:w % 65536) + s:w / 65536
	let res=s:z/65536 + s:w
	return res<0 ? -res : res
endfunction

"return integer within [a,b)
function! s:RandInt(a,b)
	return s:Rand()%(a:b-a:a)+a:a
endfunction

"return random double in [0,1)
function! s:RandDouble()
	let magic=89513
	return s:Rand()%magic*1.0/magic
endfunction

function! s:Build2DArray(n,m,v)
	let res=[]
	for i in range(a:n)
		let row=[]
		for j in range(a:m)
			call add(row,a:v)
		endfor
		call add(res,row)
	endfor
	return res
endfunction

function! s:RemoveWallWithProbability(i,j,p)
	if s:RandDouble() < a:p
		let s:maze[a:i][a:j]=' '
		return 1
	endif
	return 0
endfunction

function! s:BuildFullGrid()
	let R=s:R
	let C=s:C
	let s:maze=s:Build2DArray(2*R+1,2*C+1,' ')
	for i in range(0,R)
		for j in range(0,C)
			let s:maze[2*i][2*j]='+'
		endfor
	endfor
	for j in range(0,C)
		for i in range(0,R-1)
			let s:maze[2*i+1][j*2]='|'
		endfor
	endfor
	for i in range(0,R)
		for j in range(0,C-1)
			let s:maze[2*i][j*2+1]='-'
		endfor
	endfor
endfunction

function! s:PrintMaze()
	let s:maze[s:target[0]][s:target[1]]='X'
	let s:maze[s:you[0]][s:you[1]]='@'
	for i in range(len(s:maze))
		"line index starts from 1
		let line=join(s:maze[i],'')
		let line=substitute(line,' ','`','g')	"for highlight matching. ' ' appears in normal text too often
		let line=substitute(line,'.','&&','g')
 		let line=substitute(line,'XX','><','g')
		
		call setline(i+1,line)
	endfor
	let s:maze[s:you[0]][s:you[1]]=' '
	let s:maze[s:target[0]][s:target[1]]=' '
	call setline(len(s:maze)+1,"")
	call setline(len(s:maze)+2,"Use h,j,k,l to bring you('@') to the target('X')")
	call setline(len(s:maze)+3,"type q to quit the game")
endfunction

let s:p=[]    "parent array for disjoint set
function! s:Root(i)
	let i=a:i
	if s:p[i] == i
		return i
	else
		let s:p[i]=s:Root(s:p[i])
		return s:p[i]
	endif
endfunction

function! s:Merge(a,b)
	let a=a:a
	let b=a:b
	let s:p[s:Root(a)]=s:Root(b)
endfunction

function! s:Valid(i,j)
	return a:i>=0 && a:i<=2*s:R && a:j>=0 && a:j<=2*s:C
endfunction


function! s:GetProbability(i,j)
	let i=a:i
	let j=a:j
	let d=[[-1,-1],[0,-2],[1,-1],[1,1],[0,2],[-1,1]]
	let ct=0
	let filled=0
	for p in d
		let ti=i+p[i%2]
		let tj=j+p[j%2]
		if s:Valid(ti,tj)
			let ct+=1
			if s:maze[ti][tj]!=' '
				let filled+=1
			endif
		endif
	endfor
	let r=1.0*filled/ct
	return pow(r,s:difficulty)
endfunction

function! s:GetProgressBar(total,missing)
	let bar="Constructing Maze: |"
	let n=float2nr(1.0*a:missing/a:total*20)
	for i in range(n)
		let bar.="=|"
	endfor
	return bar
endfunction

function! s:RandomlyRemoveWalls()
	"build map spend most time here
	let s:p=[]
	let R=s:R
	let C=s:C
	"0: up, 1:down, 2:left, 3:right
	let d=[[-1,0],[1,0],[0,-1],[0,1]]
	for i in range(R*C)
		call add(s:p,i)
	endfor
	"candidate list of walls to be removed
	let cand=[]
	"add all vertical walls into candidate list
	for i in range(R)
		for j in range(C-1)
			call add(cand,[i,j,3])
		endfor
	endfor
	"add all horizontal walls into candidate list
	for i in range(R-1)
		for j in range(C)
			call add(cand,[i,j,1])
		endfor
	endfor
	let total=len(cand)
	let missing=0
	while len(cand) > 0
		let randIdx=s:RandInt(0,len(cand))
		let x=cand[randIdx][0]
		let y=cand[randIdx][1]
		let idx=cand[randIdx][2]
		call remove(cand,randIdx)
		
		let i=1+2*x
		let j=1+2*y
		let i+=d[idx][0]
		let j+=d[idx][1]

		"
		"only need to check two case now
		"
		if idx==1
			let con=[x*C+y,(x+1)*C+y]
		else
			let con=[x*C+y,x*C+y+1]
		endif

		"this check still needed
		if s:Root(con[0])==s:Root(con[1])
			continue
		endif

		let p=s:GetProbability(i,j)
		if s:RemoveWallWithProbability(i,j,p)
			" wall removed!!
			redraw
			echo s:GetProgressBar(total,missing)
			call s:Merge(con[0],con[1])
			let missing+=1
		else
			" you are not chosen onlg because you are not lucky enough
			" better luck next time
			call add(cand,[x,y,idx])
		endif
	endwhile
	redraw
	echo "Done"
endfunction


function! s:FindFarthestPoint()
	"starting point is s:you's logical coordinate
	let si=s:you[0]/2
	let sj=s:you[1]/2
	let Q=[[si,sj]]
	let dis=s:Build2DArray(s:R,s:C,-1)
	let dis[si][sj]=0
	let maxDis=0
	let d=[[-1,0],[1,0],[0,-1],[0,1]]
	while len(Q)!=0
		let p=get(Q,0)
		call remove(Q,0)
		let i=p[0]
		let j=p[1]
		for idx in range(4)
			let ti=i+d[idx][0]
			let tj=j+d[idx][1]
			if s:maze[i+1+ti][j+1+tj]==' ' && dis[ti][tj]==-1
				call add(Q,[ti,tj])
				let dis[ti][tj]=dis[i][j]+1
				let maxDis=max([maxDis,dis[ti][tj]])
			endif
		endfor
	endwhile
	for i in range(s:R)
		for j in range(s:C)
			if dis[i][j]==maxDis
				return [i*2+1,j*2+1]
			endif
		endfor
	endfor
endfunction

function! s:BuildMaze()
	let R=s:R
	let C=s:C
	call s:BuildFullGrid()
	call s:RandomlyRemoveWalls()
	let s:you=[1,1]
	let s:target=s:FindFarthestPoint()
endfunction

let s:konami=0
let s:konamiMode=0


function! s:HandleKonamiCode(c)
	let c=a:c
	let correct=0
	if (s:konami==0 || s:konami==1)
		let correct = (c=='k')
	elseif (s:konami==2 || s:konami==3)
		let correct = (c=='j')
	elseif (s:konami==4 || s:konami==6)
		let correct = (c=='h')
	elseif (s:konami==5 || s:konami==7)
		let correct = (c=='l')
	elseif s:konami==8
		let correct = (c=='b')
	elseif s:konami==9
		let correct = (c=='a')
	endif
	
	if correct
		let s:konami+=1
	else
		let s:konami=0
	endif

	if s:konami==10
		let s:konami=0
		let s:konamiMode+=1
		let s:targetHistory=s:Build2DArray(2*s:R+1,2*s:C+1,0)
		let s:targetHistory[s:target[0]][s:target[1]]=1
		echo 'hallelujah !'
	endif
endfunction

function! s:RandomMoveTarget()
	"OK..it's not really random
	let d=[[-1,0],[1,0],[0,-1],[0,1]]
	let cand=[]
	for p in d
		let i=s:target[0]+p[0]
		let j=s:target[1]+p[1]
		if s:Valid(i,j) && s:maze[i][j]==' '
			call add(cand,[i,j])
		endif
	endfor
	"choose the location least walked on
	let minNum=10000
	for p in cand
		let i=p[0]
		let j=p[1]
		if minNum > s:targetHistory[i][j]
			let minNum = s:targetHistory[i][j]
			let s:target = p
		endif
	endfor
	let s:targetHistory[s:target[0]][s:target[1]]+=1
endfunction

function! s:HandleKeyInput(c)
	let c=nr2char(a:c)
	"for fun
	call s:HandleKonamiCode(c)
	"handle difficulty control
	if c=='q'
		q!
		return 1
	endif
	"handle movement
	let i=s:you[0]
	let j=s:you[1]
	if c=='h'
		let j-=1
	elseif c=='j'
		let i+=1
	elseif c=='k'
		let i-=1
	elseif c=='l'
		let j+=1
	endif
	if s:maze[i][j]==' '
		let s:you[0]=i
		let s:you[1]=j
	endif

	for i in range(s:konamiMode)
		call s:RandomMoveTarget()
	endfor

	return 0
endfunction


function! s:CheckWin()
	return s:you[0]==s:target[0] && s:you[1]==s:target[1]
endfunction

function! s:MainLoop()
	while 1
		"print maze in new window
		call s:PrintMaze()
		redraw
		if s:CheckWin()
			echo "Congratulations!"
			echo "You got it!"
			q!
			break
		endif
		let c=getchar()
		if s:HandleKeyInput(c)==1
			break
		endif
	endwhile
endfunction

function! s:Error(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction
	
"maximal possible size for current window 
function! s:MaxAllowedHeight()
	return (winheight(0)-4)/2
endfunction

function! s:MaxAllowedWidth()
	return (winwidth(0)-10)/4
endfunction

function! s:SuggestMazeSize(R,C)
	" Give game size hint.
	" May not always do as the suggested:
	" Too small size hint will result in 5*5 maze(minimal size).
	" Too large size hint will result in maximal possible maze for current
	" window.
	let R=a:R
	let C=a:C
	let size=[s:MaxAllowedHeight(),s:MaxAllowedWidth()]
	if R >= 5 && R <= size[0]
		let s:R = R
	elseif R < 5
		let s:R=5
	else
		let s:R = size[0]
	endif
	if C >= 5 && C <= size[1]
		let s:C = C
	elseif C < 5
		let s:C=5
	else
		let s:C = size[1]
	endif
endfunction

function! s:HJKL(...)
	if bufname("%") != ''
	"create new window for game
		new
		resize 100
	endif
	
	"check whether window size is large enough to hold minimal game
	if winheight(0) < 15 || winwidth(0) < 30
		call s:Error("Need larger window size! Don't be so mean!")
		let c=getchar()
		q!
		return 
	endif
	if a:0==2
		"3 horizontal lines reserved for printing
		"messages
		call s:SuggestMazeSize(a:1,a:2)
	else
		"default size of maze
		call s:SuggestMazeSize(15,20)
	endif
	let s:konamiMode=0
	"initialization done
	
	"build random maze
	call s:BuildMaze()
	"create new window
	
	"setup syntax highlight
	syntax match Wall "+"
	syntax match Wall "-"
	syntax match Wall "|"
	syntax match Empty "`"
	syntax match Target "><"
	syntax match You "@"

	hi Wall ctermfg=Black ctermbg=Black guibg=Black guifg=Black
	hi Empty ctermfg=White ctermbg=White guibg=White guifg=White
	hi Target ctermfg=DarkRed ctermbg=White guibg=White guifg=DarkRed term=bold cterm=bold gui=bold
	hi You ctermfg=DarkGreen ctermbg=White guibg=White guifg=DarkGreen term=bold cterm=bold gui=bold
	"main loop
	call s:MainLoop()

endfunction

command! -nargs=* HJKL call s:HJKL(<f-args>)

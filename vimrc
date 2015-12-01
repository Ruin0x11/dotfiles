set nocompatible

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

call vundle#end()

syntax enable

filetype plugin indent on

" let g:base16_shell_path="~/build/base16-builder/output/shell"
" set t_Co=256
" let base16colorspace=256
" colorscheme base16-mdk
" set background=dark

colorscheme Tomorrow-Night

set autochdir
set autoindent
set autoread
set backupcopy=yes
set complete=k
set clipboard=unnamed
set cmdheight=2
set dictionary=/usr/share/dict/web2
set directory=.
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,sjis,default
set expandtab
set fileencodings=ucs-bom,utf-8,sjis,default
set ffs=unix,dos
set hidden
set hlsearch
set ignorecase
set iminsert=0
set incsearch
set laststatus=2
set lazyredraw
set linespace=1
set nowrap
set number
set ruler
set scrolloff=3
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set tabstop=4
set tags=./tags,./TAGS,tags,TAGS,~/.vimtags
set timeoutlen=500
set virtualedit+=block
set wildmenu
set wildmode=longest,list,full
set wrap

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

set mouse=a

call yankstack#setup()

" let mapleader = ','
let mapleader = "\<Space>"
" map <Space> <C-f>
map <C-Space> ?
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>bd :Bclose<cr>
nmap <Leader>d :NERDTreeToggle %:p<CR>
nmap <Leader>f :NERDTreeFind<CR>
nmap <Leader>t :CtrlP<CR>
nmap <Leader>v :e $MYVIMRC<CR>
nmap <Leader>b :e $HOME/.vimrc.bundles<CR>
nmap <Leader><Leader>v :spl $MYVIMRC<CR>
" nmap <Leader>s :OpenSession!<CR>
nmap <Leader>s :mksession!<CR>
nmap <Leader>w :w!<CR>
nmap <Leader>x :x<CR>
nmap <Leader>q :q<CR>
nmap <Leader>Y :%y+<CR>
nmap <Leader>n :cn<CR>
nmap <Leader>p :cp<CR>
nnoremap <leader>u :GundoToggle<CR>
map <silent> <Leader>sv :so ~/.vimrc<CR>:filetype detect<CR>:exe "echo '.vimrc reloaded.'"<CR>
map <silent> <Leader>sb :so ~/.vimrc<CR>:filetype detect<CR>:BundleInstall<CR>:q<CR>:exe "echo 'Bundles installed!'"<CR>
"cmap Q q
map <Leader>tn :tabnew<CR>
map <Leader>tc :tabclose<CR>
map <Leader>to :tabonly<CR>
map <M-Space> <ESC>
map <silent> <leader><cr> :noh<cr>
map <leader>cd :cd %:p:h<cr>:pwd<cr>
map Y y$

map <Leader>g :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

map q: :q
nmap <Leader>y "+y
nmap <Leader>Y "+Y
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<localleader>c'
let g:tslime_visual_mapping = '<localleader>c'
let g:tslime_vars_mapping = '<localleader>C'

let g:niji_dark_colours = [
    \ [ '81', '#5fd7ff'],
    \ [ '99', '#875fff'],
    \ [ '1',  '#dc322f'],
    \ [ '76', '#5fd700'],
    \ [ '3',  '#b58900'],
    \ [ '2',  '#859900'],
    \ [ '6',  '#2aa198'],
    \ [ '4',  '#268bd2'],
    \ ]

nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" autocmd VimEnter * unmap! ,w=
map <Leader>W= <Plug>AM_w=

vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" cnoreabbrev :man :help

map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
" nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" auto-brackets
nnoremap {      i{}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

set makeprg=javac\ %
set errorformat=%A:%f:%l:\ %m,%-Z%p^,%-C%.%#

autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
autocmd BufRead set makeprg=ant\ -find\ build.xml

autocmd filetype lisp,scheme,art setlocal equalprg=scmindent.rkt
autocmd BufRead *.ui set ft=json
autocmd BufRead *.skin set ft=json
autocmd BufRead *.fasm set ft=ia64

autocmd BufRead *.rb set shiftwidth=2
autocmd BufRead *.erb set shiftwidth=2

hi link CTagsClass Type
hi link CTagsEnumerationValue Constant
hi link CTagsField Define
hi link CTagsEnumeratorName Type
hi link CTagsInterface Identifier
hi link CTagsLocalVariable Constant
hi link CTagsMethod Special
hi link CTagsPackage Identifier

let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:NERDTreeShowBookmarks = 1
let g:session_autoload='no'
let g:session_autosave='yes'
let g:airline_powerline_fonts = 1
let g:evervim_devtoken='S=s128:U=d5d6ef:E=14a3546098c:C=142dd94dd90:P=1cd:A=en-devtoken:V=2:H=05bc9ceebb726dd03a3c1a620ccfc697'
let g:atp_Python = "/usr/bin/python2"
let b:atp_Viewer = "xpdf"
let g:notes_directories = ['~/Dropbox/Illinois/II/Notes']
let g:todo_log_done = 0
let g:todo_log_into_drawer = ""
let g:todo_state_colors={'SOMEDAY': 'Yellow'}
let g:todo_states=[['TODO(t)', '|', 'DONE(d)', 'CANCELLED(c)'], ['WAITING(w)', 'HOLD(h)', 'INPROGRESS(i)', 'SOMEDAY(s)', 'CLOSED(l)']]

let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_auto_trigger = 1
let g:paredit_leader = '\'

let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:EclimCompletionMethod = 'omnifunc'

let g:closetag_filenames = "*.html,*.xhtml,*.phtml"

" stolen crud
function! VisualSelection(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	elseif a:direction == 'gv'
		call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
	elseif a:direction == 'replace'
		call CmdLine("%s" . '/'. l:pattern . '/')
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr("%") == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute("bdelete! ".l:currentBufNum)
	endif
endfunction
"
" Delete range without moving cursor:
com! -range D <line1>,<line2>d | norm <C-o> 

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

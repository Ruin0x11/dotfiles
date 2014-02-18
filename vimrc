set nocompatible

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

syntax enable

filetype plugin indent on

set autoindent
set autoread
set backupcopy=yes
set clipboard=unnamed
set cmdheight=2
set directory=.
set encoding=utf-8
set ffs=unix,dos
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linespace=1
set nowrap
set number
set ruler
set scrolloff=3
set shiftwidth=8
set showcmd
set smartcase
set wildmenu
set wildmode=longest,list,full
set wrap

set mouse=a

let mapleader = ','
map <Space> /
map <C-Space> ?
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>bd :Bclose<cr>
nmap <Leader>d :NERDTreeToggle<CR>
nmap <Leader>f :NERDTreeFind<CR>
nmap <Leader>t :CtrlP<CR>
nmap <Leader>v :e $MYVIMRC<CR>
nmap <Leader>s :OpenSession!<CR>
nmap <Leader>w :w!<CR>
nmap <Leader>x :x<CR>
nmap <Leader>q :q<CR>
nmap <Leader>y :%y+<CR>
map <silent> <Leader>V :so ~/.vimrc<CR>:filetype detect<CR>:exe "echo '.vimrc reloaded.'"<CR>
cmap Q q
map <Leader>tn :tabnew<CR>
map <Leader>tc :tabclose<CR>
map <Leader>to :tabonly<CR>
map <M-Space> <ESC>
map <silent> <leader><cr> :noh<cr>
map <leader>cd :cd %:p:h<cr>:pwd<cr>

nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
" nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>

" auto-brackets
nnoremap {      i{}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

set makeprg=javac\ %
set errorformat=%A:%f:%l:\ %m,%-Z%p^,%-C%.%#

let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:NERDTreeShowBookmarks = 1
let g:session_autoload='no'
let g:session_autosave='yes'
let g:airline_powerline_fonts = 1
let g:evervim_devtoken='S=s128:U=d5d6ef:E=14a3546098c:C=142dd94dd90:P=1cd:A=en-devtoken:V=2:H=05bc9ceebb726dd03a3c1a620ccfc697'
let g:atp_Python = "/usr/bin/python"
let b:atp_Viewer = "xpdf"
let g:notes_directories = ['~/Dropbox/Illinois/II/Notes']

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

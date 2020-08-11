syntax on
set relativenumber			" show relative line numbers 2,1,*0,1,2
set showmatch				" show matching brackets
set tabstop=4				" set tab length
set shiftwidth=4			" set < > commands indents
set splitbelow				" horisonal spilt below current
set splitright				" vertical split right of current
set autoread				" reload unedited files
set autoindent				" try to auto indent
set gdefault				" use global flag when substituting s/o/r/(g)
set clipboard+=unnamedplus	" use system cliboard by default (use with cutless)

" highlight traling whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" vimwiki settings
" set leader key
let g:vimwiki_list = [{'path': '~/files/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

"let mapleader="\<SPACE>"

" Search and Replace
nmap \ :%s//g<Left><Left>

" Yea, just one mod button less to press
nnoremap ; : 
" instert newline, staying in normal mode
nnoremap <CR> i<CR><Esc>
" same but above current line
nnoremap <S-CR> O<Esc>
" move line(s) down/up with tab/shift-tab
nnoremap <Tab> :m .+1<CR>==
nnoremap <S-Tab> :m .-2<CR>==
vnoremap <Tab> :m '>+1<CR>gv=gv
vnoremap <S-Tab> :m '<-2<CR>gv=gv

" use x as cut, (default delete behavier)
nnoremap x d
xnoremap x d
vnoremap x d
nnoremap xx dd
nnoremap X D

" editor commands
command Q q!
command W w!
command CD !mkdir -p %:h
"command! -nargs=? W		call s:Write(' w!',	<args>)
"command! -nargs=? WQ	call s:Write("wq!",	<args>)

"function! s:Write(cmd, ...)
	"let file = get(a:, 1, expand("%"))
	"echo "" . file:h
	"normal! :!mkdir -p file:h 
	"normal! cmd file
"endfunction

"let g:airline_statusline_ontop=1
let g:airline_theme='jellybeans'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

call plug#begin(stdpath('data') . '/plugged')

"Web dev
"Plug 'digitaltoad/vim-pug'
"Plug 'hail2u/vim-css3-syntax'
"Plug 'skammer/vim-css-color'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }

" looks
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dylanaraps/wal.vim'

" behavier
Plug 'svermeulen/vim-cutlass'

call plug#end()

colorscheme wal

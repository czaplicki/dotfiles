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

set modeline
set modelines=5

" Start in insert mode on new files
autocmd BufNewFile * startinsert

autocmd FileType haskell setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab nowrap
autocmd FileType cabal setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" syntax
autocmd BufNewFile,BufRead *sxhkd   set syntax=sxhkd

autocmd BufNewFile,BufRead */xresourcess.d/*   set syntax=sxhkd

" highlight traling whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

let mapleader="\<SPACE>"

" Search and Replace
nmap \ :%s//<Left>

" Yea, just one mod button less to press
nnoremap ; :
" instert newline, staying in normal mode
nnoremap <CR> i<CR><Esc>
" same but above current line
nnoremap <S-CR> O<Esc>

" move line(s) down/up with tab/shift-tab
nnoremap <silent> <Tab> :m .+1<CR>==
nnoremap <silent> <S-Tab> :m .-2<CR>==
vnoremap <silent> <Tab> :m '>+1<CR>gv=gv
vnoremap <silent> <S-Tab> :m '<-2<CR>gv=gv

" use x as cut, (default delete behavier)
nnoremap <silent> x d
xnoremap <silent> x d
vnoremap <silent> x d
nnoremap <silent> xx dd
nnoremap <silent> X D

" void characters when using Delete key
nnoremap <DS> "_x
xnoremap <DS> "_x
vnoremap <DS> "_x


" editor commands
command Q q!
command W w!
command WQ w!q

" unbind arrows in normal & visual mode
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>


" vimwiki settings
let g:vimwiki_list = [{'path': '/src/github.com/czaplicki/czaplicki.github.io/', 'syntax': 'markdown', 'ext': '.md'}]

"let g:airline_statusline_ontop=1
let g:airline_theme='jellybeans'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

call plug#begin(stdpath('data') . '/plugged')

" syntax
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'leafo/moonscript-vim'
Plug 'kovetskiy/sxhkd-vim'
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'neovimhaskell/haskell-vim'
Plug 'dag/vim-fish'

Plug 'vito-c/jq.vim'

" looks
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dylanaraps/wal.vim'

" behavier
Plug 'svermeulen/vim-cutlass'
Plug 'tpope/vim-surround'

" functionality
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary'

" browser imbedment
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }


call plug#end()

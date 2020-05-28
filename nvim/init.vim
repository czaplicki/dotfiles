syntax on
set relativenumber	" show relative line numbers 2,1,*0,1,2
set showmatch		" show matching brackets
set tabstop=4		" set tab length
set shiftwidth=4	" set < > commands indents
set splitbelow		" horisonal spilt below current
set splitright		" vertical split right of current
set autoread		" reload unedited files
set autoindent		" try to auto indent
set gdefault		" use global flag when substituting s/o/r/(g)

" highlight traling whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" vimwiki settings
let g:vimwiki_list = [{'path': '~/files/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" set leader key
let mapleader="\<SPACE>"

" Search and Replace
nmap <Leader>sr :%s//g<Left><Left>
nnoremap ; :


"let g:airline_statusline_ontop=1
"let g:airline_theme='jellybeans'
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

" looks
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dylanaraps/wal.vim'

call plug#end()

colorscheme wal

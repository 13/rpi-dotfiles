"pathogen
execute pathogen#infect()

"default
syntax on
filetype plugin indent on
set number
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

"base16
"colorscheme base16-solarized-dark
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace

"airline
set laststatus=2 " Always show the statusline
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist' "minimalist sol deus powerlineish
let g:airline_solarized_bg='dark'

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"antiword
autocmd BufReadPre *.doc set ro
autocmd BufReadPre *.doc set hlsearch!
autocmd BufReadPost *.doc %!antiword "%"


filetype off
set nocompatible
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'airblade/vim-gitgutter'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nono/vim-handlebars'
Plugin 'matchit.zip'
Plugin 'bling/vim-airline'
Plugin 'Blackrush/vim-gocode'
Plugin 'ervandew/supertab'
Plugin 'chriskempson/base16-vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'jeetsukumaran/vim-buffergator'

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1

syntax on
filetype plugin indent on

"" general settings
set hidden
set backspace=indent,eol,start
let mapleader = ","
set nowrap
set autoread
set history=1000
if has("gui_running")
  set guioptions=egmt
  set guicursor+=a:blinkon0
endif
set backupdir=~/.vimtmp
set directory=~/.vimtmp

"" statusline settings
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#right_sep=' '
let g:airline#extensions#tabline#right_alt_sep='|'


"" indentation settings
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

"" tab completion settings
set wildmenu
set wildmode=list:longest,full

"" mappings
map <leader>t :set ft=
imap jj <esc>

" Move to the previous buffer with "gp"
nnoremap gN :bp<CR>

" Move to the next buffer with "gn"
nnoremap gn :bn<CR>

" List all possible buffers with "gl"
nnoremap gl :ls<CR>

" List all possible buffers with "gb" and accept a new buffer argument [1]
nnoremap gb :ls<CR>:b

" delete buffer
map <leader>d :bd<CR>

"" look and feel (margins, colors, etc)
colorscheme base16-tomorrow
syntax enable
set background=dark
set number
set cul
set guifont=Source\ Code\ Pro\ for\ Powerline:h15
set colorcolumn=120
set synmaxcol=240
set textwidth=100
set wrapmargin=0
set list listchars=trail:·

"" customize the default color scheme a little bit
set fillchars=vert:\|,stl:\ ,stlnc:\
"hi StatusLine guibg=#DDDDDD guifg=#222222
"hi StatusLineNC guibg=#BBBBBB guifg=#222222
"hi VertSplit guibg=#DDDDDD
"hi Search guibg=LightBlue

"" search settings
set incsearch
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"" automatically reload vimrc after it is saved
autocmd! bufwritepost .vimrc source %

"" automatically strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"" NERDTree plugin configuration
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>

"" close nerdtree if its the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"" CtrlP plugin configuration
let g:ctrlp_open_new_file = "t"
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](\.git|node_modules|log|tmp|public\/docs|public\/uploads|db\/fixtures)$' }

""ctrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

function! HashReformat()
 %s/:\(\w\+\)\(\s*=>\s*\)/\1: /gce
endfunction

command! HashReformat call HashReformat()
com! FormatJSON %!python -m json.tool

map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>

let g:syntastic_disabled_filetypes = ['scss', 'sass', 'hbs']

com! ZeusTest call system("yes exit | zeus test " . shellescape(expand("%")) . "&")
com! ZeusTestAll call system("yes exit | zeus test spec/ &")
nnoremap <leader>z :ZeusTest<cr>
nnoremap <leader>Z :ZeusTestAll<cr>


"" Git gutter
highlight clear SignColumn

" Write all writeable buffers when changing buffers or losing focus.
set autowriteall                " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall  " Save anytime we leave a buffer or MacVim loses focus.
"
"Clojure
autocmd Syntax clojure RainbowParenthesesLoadRound
autocmd BufEnter *.clj RainbowParenthesesToggle
autocmd BufLeave *.clj RainbowParenthesesToggle

let g:rbpt_max = 9
"
""ACK
map <leader>a :Ack! "<cword>"<CR>

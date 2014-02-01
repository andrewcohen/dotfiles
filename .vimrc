filetype off
set rtp+=~/.vim/bundle/vundle

call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'justinmk/vim-sneak'
Bundle 'mileszs/ack.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'ervandew/supertab'
Bundle 'Townk/vim-autoclose'
Bundle 'airblade/vim-gitgutter'
Bundle 'kchmck/vim-coffee-script'

"" general settings
set hidden
let mapleader = ","
set nowrap
set autoread
set history=1000
if has("gui_running")
  set guioptions=egmt
endif
set backupdir=~/.vimtmp
set directory=~/.vimtmp

"" statusline settings
set laststatus=2
let g:airline_powerline_fonts = 1

"" indentation settings
filetype plugin on
filetype indent on
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
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"" look and feel (margins, colors, etc)
colorscheme solarized
syntax enable
set background=dark
set number
set cul
set guifont=Source\ Code\ Pro\ for\ Powerline:h13
set colorcolumn=120
set textwidth=100
set wrapmargin=0
set list listchars=trail:·

"" customize the default color scheme a little bit
set fillchars=vert:\|,stl:\ ,stlnc:\
hi StatusLine guibg=#DDDDDD guifg=#222222
hi StatusLineNC guibg=#BBBBBB guifg=#222222
hi VertSplit guibg=#DDDDDD
hi Search guibg=LightBlue

"" search settings
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"" automatically reload vimrc after it is saved
autocmd! bufwritepost .vimrc source %

"" automatically strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"" NERDTree plugin configuration
nmap <leader>n :NERDTreeToggle<CR>
"" close nerdtree if its the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"" CtrlP plugin configuration
let g:ctrlp_open_new_file = "t"
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](\.git|node_modules|log|tmp|public\/docs|public\/uploads|db\/fixtures)$' }


""ctrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

""html closetag
let g:closetag_html_style = 1
au Filetype html,html.erb, source ~/.vim/bundle/closetag.vim

""handlebars/moustache
let g:mustache_abbreviations = 1

function! HashReformat()
 %s/:\(\w\+\)\(\s*=>\s*\)/\1: /gce
endfunction

command! HashReformat call HashReformat()
com! FormatJSON %!python -m json.tool

let g:syntastic_disabled_filetypes = ['scss', 'sass']

com! ZeusTest call system("zeus test " . shellescape(expand("%")) . "&")
com! ZeusTestAll call system("zeus test spec/ &")
nnoremap <leader>z :ZeusTest<cr>
nnoremap <leader>Z :ZeusTestAll<cr>

com! CopyCurrentPath call system("echo " . expand("%") . "|pbcopy")
nnoremap <leader>C :CopyCurrentPath<cr>

"" Git gutter
highlight clear SignColumn

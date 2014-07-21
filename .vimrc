filetype off
set nocompatible
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-haml'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'airblade/vim-gitgutter'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nono/vim-handlebars'
Plugin 'bling/vim-airline'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'matchit.zip'
Plugin 'rizzatti/dash.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-fireplace'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-clojure-highlight'
Plugin 'paredit.vim'
Plugin 'fatih/vim-go'
Plugin 'majutsushi/tagbar'

call vundle#end()

autocmd InsertLeave * if pumvisible() == 0|pclose|endif
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1

syntax on
filetype plugin indent on

"" general settings
set visualbell t_vb=
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
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#right_sep=' '
let g:airline#extensions#tabline#right_alt_sep='|'
let g:airline#extensions#tabline#show_buffers = 0

""" indentation settings
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

""" tab completion settings
set wildmenu
set wildmode=list:longest,full

""" mappings
imap jj <esc>

""" look and feel (margins, colors, etc)
set background=dark
set number
"set cul
colorscheme Tomorrow-Night-Eighties
set guifont=Inconsolata-dz\ for\ Powerline:h15
set colorcolumn=120
set synmaxcol=240
set textwidth=100
set wrapmargin=0
set list listchars=trail:·

set fillchars=vert:\|,stl:\ ,stlnc:\
set listchars=tab:~\ ,extends:#,nbsp:.

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
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](\.git|target|node_modules|log|tmp|out|public\/docs|public\/uploads|db\/fixtures)$' }

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

let g:syntastic_disabled_filetypes = ['scss', 'sass', 'hbs', 'handlebars.html']

"" Git gutter
highlight clear SignColumn

" Write all writeable buffers when changing buffers or losing focus.
set autowriteall                " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall  " Save anytime we leave a buffer or MacVim loses focus.
"
"Clojure
autocmd Filetype clojure RainbowParenthesesActivate
autocmd Filetype clojure RainbowParenthesesLoadRound
autocmd Filetype clojure RainbowParenthesesLoadSquare
autocmd Filetype clojure RainbowParenthesesLoadBraces

let g:rbpt_max = 9

map <leader>a :Ack! "<cword>"<CR>
map <leader>v :vsplit <CR>
map <leader>r :Require <CR>

map <leader>t :TagbarToggle <CR>
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

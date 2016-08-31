call plug#begin('~/.vim/plugins')

Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-haml', { 'for': 'haml' }
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/syntastic'
Plug 'ervandew/supertab'
Plug 'andrewcohen/tomorrow-theme', {'rtp': 'vim/'}
Plug 'airblade/vim-gitgutter'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
Plug 'mustache/vim-mustache-handlebars', { 'for': 'handlebars' }
Plug 'bling/vim-airline'
Plug 'matchit.zip'
Plug 'rizzatti/dash.vim'
Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'paredit.vim', { 'for': 'clojure' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'skwp/greplace.vim'
Plug 'sjl/gundo.vim'
Plug 'SirVer/ultisnips'
Plug 'szw/vim-ctrlspace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'goatslacker/mango.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'chase/vim-ansible-yaml', { 'for': 'yaml' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'slashmili/alchemist.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kassio/neoterm'
Plug 'lambdatoast/elm.vim'
Plug 'morhetz/gruvbox'

call plug#end()

syntax on
filetype plugin indent on

"" general settings
set visualbell t_vb=
set hidden
set backspace=indent,eol,start
let mapleader = "\<Space>"
set nowrap
set autoread
set history=1000
if has("gui_running")
  set guioptions=egmt
  set guicursor+=a:blinkon0
endif
set backupdir=~/.vimtmp
set directory=~/.vimtmp

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
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
let g:airline_exclude_preview = 1

""" indentation settings
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

""" tab completion settings
set wildmenu
set wildmode=list:longest,full

""" vim command settings
set ignorecase
set smartcase

""" mappings
imap jj <esc>
imap jk <esc>
imap kj <esc>
map Y y$
nmap <leader>s  :%s/
vmap <leader>s  :s/
vmap <leader>y "+y
nnoremap <leader>S  :%s/\<<C-r><C-w>\>/
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

""" look and feel (margins, colors, etc)
set background=dark
set number
set cul
colorscheme hybrid
set guifont=Inconsolata-dz\ for\ Powerline:h13
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
nmap <leader><Space> :nohlsearch<Bar>:echo<CR>

"" terminal / neoterm
" enter terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" enable esc to exit insert mode in terminal
tnoremap <Esc> <C-\><C-n>

" break out of terminal insert mode with window movements
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>h <c-\><c-n><c-w>h
tnoremap <c-w>l <c-\><c-n><c-w>l
tnoremap <c-w>J <c-\><c-n><c-w>J
tnoremap <c-w>K <c-\><c-n><c-w>K
tnoremap <c-w>H <c-\><c-n><c-w>H
tnoremap <c-w>L <c-\><c-n><c-w>L
tnoremap <c-w>x <c-\><c-n><c-w>x

nnoremap <silent> <leader>tn :TREPLSend<cr>
nnoremap <silent> <leader>tf :TREPLSendFile<cr>
nnoremap <silent> <leader>rt :call neoterm#test#run('all')<cr>
nnoremap <silent> <leader>rf :call neoterm#test#run('file')<cr>
nnoremap <silent> <leader>rn :call neoterm#test#run('current')<cr>
nnoremap <silent> <leader>rr :call neoterm#test#rerun()<cr>
" hide/close terminal
nnoremap <silent> <leader>th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> <leader>tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> <leader>tc :call neoterm#kill()<cr>


"" automatically strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"" NERDTree plugin configuration
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>
let NERDTreeShowHidden=1

"" close nerdtree if its the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

function! HashReformat()
 %s/:\(\w\+\)\(\s*=>\s*\)/\1: /gce
endfunction

command! HashReformat call HashReformat()
com! FormatJSON %!python -m json.tool

map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>
"" copy to system clipboard
map <leader>cc "*y

let g:syntastic_disabled_filetypes = ['scss', 'sass', 'hbs', 'handlebars.html']
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

""" FZF
let g:fzf_layout = { 'up': '30%' }
nnoremap <C-P> :FZF<CR>

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
map <leader>v :vsplit <CR>
autocmd Filetype clojure nmap <leader>r :Require <CR>

" autocmd go
autocmd filetype go set nolist
let g:go_fmt_command = "goimports"

set grepprg=ack
let g:grep_cmd_opts = '--noheading'

let g:SuperTabDefaultCompletionType = "context"
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
let g:SuperTabClosePreviewOnPopupClose = 1

let g:tmuxline_powerline_separators = 0
let g:jsx_ext_required = 0

" rust racer completion
let g:racer_cmd = "~/.cargo/bin/racer"
let $RUST_SRC_PATH="/usr/local/src/rust/src/"

autocmd filetype cpp set shiftwidth=4
autocmd filetype cpp set softtabstop=4
autocmd filetype cpp set tabstop=4

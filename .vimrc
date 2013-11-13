execute pathogen#infect()

"" general settings
set hidden
let mapleader = ","
set nowrap
set autoread
set history=1000
if has("gui_running")
  set guioptions=egmrt
endif
set backupdir=~/.vimtmp
set directory=~/.vimtmp

"" statusline settings
function! Current_branch(...)
  if !exists('b:git_dir')
    return ''
  endif
  return ' (' . fugitive#head(7) . ')'
endfunction
set laststatus=2
set statusline=%h%w\ %f\ (#%n)\ %y\ [%l:%c]\ %LL\ (%p%%)%{Current_branch()}\ %m

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
"let g:Powerline_symbols = 'fancy'
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

"" powerline plugin configuration
set rtp+=~/.vim/bundle/powerline/bindings/vim

""ctrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

""html closetag
let g:closetag_html_style = 1
au Filetype html,html.erb, source ~/.vim/bundle/closetag.vim

""handlebars/moustache
let g:mustache_abbreviations = 1

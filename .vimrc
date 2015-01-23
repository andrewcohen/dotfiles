"NeoBundle Scripts-----------------------------
if has('vim_starting')
  set nocompatible               " Be iMproved
  set runtimepath+=/Users/andrewcohen/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tpope/vim-rails.git'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-haml'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'ervandew/supertab'
NeoBundle 'andrewcohen/tomorrow-theme', {'rtp': 'vim/'}
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'mustache/vim-mustache-handlebars'
NeoBundle 'bling/vim-airline'
NeoBundle 'honza/dockerfile.vim'
NeoBundle 'matchit.zip'
NeoBundle 'rizzatti/dash.vim'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'tpope/vim-fireplace'
NeoBundle 'guns/vim-clojure-static'
NeoBundle 'guns/vim-clojure-highlight'
NeoBundle 'paredit.vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'skwp/greplace.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'szw/vim-ctrlspace'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'pangloss/vim-javascript'

call neobundle#end()

syntax on
filetype plugin indent on
NeoBundleCheck

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
map Y y$
nmap <leader>s  :%s/
vmap <leader>s  :s/
nnoremap <leader>S  :%s/\<<C-r><C-w>\>/

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

"" automatically strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"" NERDTree plugin configuration
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>

"" close nerdtree if its the only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

""""""""""""""""""
" Unite.vim
""""""""""""""""""
let g:unite_source_rec_async_command= 'ag --nocolor --nogroup -g ""'
let g:unite_source_history_yank_enable = 1

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'git5/.*/review/',
      \ 'google/obj/',
      \ 'tmp/',
      \ 'log/',
      \ '.sass-cache',
      \ 'node_modules/',
      \ 'bower_components/',
      \ 'dist/',
      \ '.git5_specs/',
      \ '.pyc',
      \ ], '\|'))


nnoremap <C-p> :Unite -buffer-name=files -start-insert file_rec/async:!<cr>
nnoremap <leader>y :Unite -buffer-name=yank history/yank<cr>
nnoremap <leader>b :Unite -buffer-name=buffer -quick-match buffer<cr>
nnoremap <leader>a :UniteWithCursorWord -keep-focus -no-quit grep:.<cr>
nnoremap <leader>A :Unite -keep-focus -no-quit grep:.<cr>

" For ag/ack.
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden --silent'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -w'
  let g:unite_source_grep_recursive_opt = ''
endif

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

""""""""""""""
" end Unite
""""""""""""""

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

set grepprg=ack
let g:grep_cmd_opts = '--noheading'

let g:SuperTabDefaultCompletionType = "context"
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
let g:SuperTabClosePreviewOnPopupClose = 1

let g:tmuxline_powerline_separators = 0

set conceallevel=1
let g:javascript_conceal_function   = "ƒ"

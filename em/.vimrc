imap jj <Esc>

let mapleader=","
set t_Co=256
set cursorline
set cc=120

filetype plugin on

if has("gui_running")
      set guioptions=egmrt
endif

" search settings
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" automatically strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

set guifont=Source\ Code\ Pro\ for\ Powerline:h11
"let g:Powerline_symbols = 'fancy'

""
"" Janus setup
""
" Define paths
let g:janus_path = escape(fnamemodify(resolve(expand("<sfile>:p")), ":h"), ' ')
let g:janus_vim_path = escape(fnamemodify(resolve(expand("<sfile>:p" . "vim")), ":h"), ' ')
let g:janus_custom_path = expand("~/.janus")

" Source janus's core
exe 'source ' . g:janus_vim_path . '/core/before/plugin/janus.vim'

" You should note that groups will be processed by Pathogen in reverse
" order they were added.
call janus#add_group("tools")
call janus#add_group("langs")
call janus#add_group("colors")

""
"" Customisations
""

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif


" Disable plugins prior to loading pathogen
exe 'source ' . g:janus_vim_path . '/core/plugins.vim'

""
"" Pathogen setup
""

" Load all groups, custom dir, and janus core
call janus#load_pathogen()

" .vimrc.after is loaded after the plugins have loaded
set rtp+=~/.janus/powerline/powerline/bindings/vim/plugin/powerline.vim

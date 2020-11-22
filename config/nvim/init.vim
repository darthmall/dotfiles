" Author: Evan Sheehan <esheehan@fastmail.com>
" Description: NeoVim configuration
" vim: set fdm=marker fdl=0 ts=2 sw=2 et tw=80 :

" I love me some line numbers.
set number
set relativenumber

" Decrease the update time to 100 milliseconds for vim-gitgutter
set updatetime=100

set noswapfile

" Ignore case as long as the query contains no capital letters.
set ignorecase smartcase

" Just because it's a terminal doesn't mean I can't use a mouse
set mouse=a

" Exclude project cruft from auto-complete/ctrl-p
set wildignore+=*/.git/*,*/node_modules/*
set wildignore+=*/dist/*,*/_site/*
set wildignore+=*.pyc,*.min.js
set wildignore+=*.png,*.PNG,*.JPG,*.jpg,*.JPEG,*.jpeg,*.GIF,*.gif,*.pdf,*.PDF,*.mov,*.mp4

" Add some keybindings for the quickfix window
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Plugins
source ~/.config/nvim/my_plugins.vim

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Close vim if the only window open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("B:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules',
  \ }

" Folding {{{
set foldenable
set foldlevel=99
set foldmethod=syntax

" Toggle folds with space
nnoremap <space> za

" SimpylFold
let g:SimpylFold_docstring_preview = 1
" }}}

" Undo {{{
" Store undo history to a file that can be restored whenever
set undofile
set undodir=~/.config/nvim/undo
set undolevels=10000
set undoreload=1000
" }}}

" Colors {{{

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

if (has("termguicolors"))
 set termguicolors
endif

syntax enable
colorscheme base16-grayscale-light

let g:python_highlight_all = 1

au BufReadPost *.svelte set syntax=html
" }}}

" Airline {{{
let g:airline_section_z = '☰ %l/%L  : %c'
" }}}

" Local configuration {{{
if filereadable(expand("~/.config/nvim/local.vim"))
  source ~/.config/nvim/local.vim
endif
" }}}
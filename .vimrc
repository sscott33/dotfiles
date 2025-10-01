" typically some sane defaults can be found here
source $HOME/.vim/custom_sources/defaults.vim

""""""""""""" Begin Vundle Setup """""""""""""
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin("$HOME/.vim/bundle")

" let Vundle manage Vundle, required
"Plugin 'gmarik/Vundle.vim'
Plugin 'VundleVim/Vundle.vim'

" add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)


" better handling of folds
"Plugin 'tmhedberg/SimpylFold'

" better python indentation
Plugin 'vim-scripts/indentpython.vim'

" better python auto-complete suggestions
" there is an issue with this plugin (ycmd server shutdown) will deal with it later
" Plugin 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }

" syntastic successor
Plugin 'dense-analysis/ale'

" syntax highlighing
"Plugin 'vim-syntastic/syntastic'
    " set python line length via flake8 config: (set -o noclobber; echo -ne '[flake8]\nmax-line-length = 130' > ~/.config/flake8)

" PEP 8 checking
"Plugin 'nvie/vim-flake8'

" git integration
"Plugin 'tpope/vim-fugitive'

"everforest colorshceme
"Plugin 'sainnhe/everforest'

" powerline
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"""""""""""""" End Vundle Setup """"""""""""""

let g:ale_python_flake8_options = '--ignore=E501'

"let g:syntastic_python_pylint_post_args="--max-line-length=120"

" options for YouCompleteMe plugin
" let g:ycm_autoclose_preview_window_after_completion=1
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>


set encoding=utf-8
          
" almost fix for that matching bracket crap (badwolf colorscheme specific)
"hi MatchParen ctermfg=208 ctermbg=bg
"set background=dark
colorscheme onedark
"let g:molokai_original = 1

" visuals """"""""""""""""""""""""""""""""""""""""
" the two following lines set hybrid line numbers
set number      " shows line numbers
set relativenumber  " shows relative line numbers

augroup numbertoggle " auto toggle for abolute and hybrid line numbers
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber number mouse=ncv
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber number mouse=ncv
augroup END

set lazyredraw      " redraw the screen only when necessary

function! Run_black()
    if count(['python'],&filetype)
        !black %
    endif
endfunction
nnoremap <leader>b :call Run_black()<CR>
"" autogroup prototype to handle cleanup after editing a python file
"augroup python_cleanup
"    autocmd BufWritePost * :call Run_black()
"augroup END


set visualbell      " disable annoying bell in windows

"set nowrap          " disable line wrapping

"set smartindent
    " don't use this

" enable syntax highlighting
syntax enable

" set tab size to 4 spaces per tab
let spaces_per_tab=4

" word wrapping and indentation
set wrap
set textwidth=130
set colorcolumn=130

" look this up at some point; explore 'K', 'C-]', and 'C-o'
set formatoptions=rq
    " r   Automatically insert the current comment leader after hitting
    "     <Enter> in Insert mode.
    " q   Allow formatting of comments with "gq".
    "     Note that formatting will not change blank lines or lines containing
    "     only the comment leader.  A new paragraph starts after such a line,
    "     or when the comment leader changes.

" set tabs to have 4 spaces
let &tabstop=spaces_per_tab

" spaces per tab in autoindent defined by tabstop; change this to override
set shiftwidth=0

" allow backspace to delete a tab's-worth of spaces
let &softtabstop=spaces_per_tab

" indent when moving to the next line while writing code
set autoindent

" round indents to multiples of shiftwidth
set shiftround

" expand tabs into spaces
set expandtab

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" enable all Python syntax highlighting features
let python_highlight_all=1

" enable more natural splitting
set splitbelow
set splitright

" more natural maneuvering between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" more natural maneuvering in/out of terminal
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>
tnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" use spacebar to open/close folds
nnoremap <space> za

" enable incrementing/decrementing octal numbers with ctrl-a and ctrl-x
"set nrformats+=octal

" searching """"""""""""""""""""""""""""""""""""""

set hlsearch        " highlight matches

set incsearch       " search as characters are entered

"set ignorecase      " searches are case-insensitive

" unhighlight search results by pressing "\<space>"
nnoremap <leader><space> :nohl<CR>

" print setings """"""""""""""""""""""""""""""""""

set printoptions=paper:letter,duplex:off

" save session and exit """"""""""""""""""""""""""
nnoremap <leader>x :wa<CR>:mks!<CR>:qa<CR>

" convert to hex and back
nnoremap <leader>h :%!xxd<CR>
nnoremap <leader>n :%!xxd -r<CR>

" search for text selected in visual mode
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" retab a 2-space/tab file to a 4-space/tab file
" https://stackoverflow.com/a/16892086
nnoremap <leader>i4 :set ts=2 sts=2 noet<CR>:retab!<CR>:set ts=4 sts=4 et<CR>:retab<CR>
nnoremap <leader>i2 :set ts=4 sts=4 noet<CR>:retab!<CR>:set ts=2 sts=2 et<CR>:retab<CR>

nnoremap <leader>t4 :set ts=4 sts=4 et<CR>
nnoremap <leader>t2 :set ts=2 sts=2 et<CR>

" get full path of current file
nnoremap <leader>f :!realpath "%"<CR>

" toggle line wrap
function! Toggle_line_wrap()
    if &wrap == 1
        set nowrap
    else
        set wrap
    endif
endfunction
nnoremap <tab> :call Toggle_line_wrap()<CR>

" update ctags, can lookup with g]
"nnoremap <leader>T :! ctags -R .<CR><CR>

" Encryption options
"set cryptmethod=blowfish2   " (requires Vim version 7.4.399 or higher)
if has('cryptv') | set cryptmethod=blowfish2 | endif

" settings for encrypted file editing: viminfo is not encrypted and thus is
" disabled, the swapfile and backups are encrypted
nnoremap <leader>e :set viminfo=<CR>
"nnoremap <leader>e :set noswapfile nobackup nowritebackup viminfo=<CR>
" older version ^^^

" mouse should be enabled, but just in case
set mouse=ncv
    "   n   Normal mode and Terminal modes
    "   v   Visual mode
    "   i   Insert mode
    "   c   Command-line mode


" function and remap to toggle mouse mode (for tmux mouse usage)
function! Toggle_mouse()
    if &mouse == "ncv"
        set mouse=
        echom 'mouse mode off'
    else
        set mouse=ncv
        echom 'mouse mode on'
    endif
endfunction

nnoremap <leader>m :call Toggle_mouse()<CR>

" suggestions from Myles

" keep cursor centered vertically
set scrolloff=999

" equalize panes when terminal is resized
autocmd VimResized * wincmd =

" hidden option allows you to cycle through buffers without having to write before switching
set hidden
noremap v V
noremap V v

" use \w to make copyable text from a visually selected region
vnoremap <leader>w :w !cat<CR>
"nnoremap <leader>w :w !cat<CR>
"
" toggle state for copy
function! Toggle_copy()
    if &mouse == "ncv"
        set nonumber norelativenumber mouse=
    else
        set number relativenumber mouse=ncv
    endif
endfunction
nnoremap <leader>c :call Toggle_copy()<CR>

" How to save a macro
" https://stackoverflow.com/a/2024537

"" swapfile and backup files directories """""""""""""""""""
set directory^=$HOME/.vim/swap//
set backupdir^=$HOME/.vim/backup//

" insert mode cursor will be a line
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" add clipboard copying (only works with a gui)
"nnoremap <leader>c :call system("/proj/darwin_block_users/users/eaktsij/xsel", getreg('"'))<CR>

" add filetype mappings (simply overloading regular syntaxes)
augroup filetype_overrides
    au!
    autocmd BufNewFile,BufRead *.sv   setlocal syntax=verilog
    autocmd BufNewFile,BufRead *.flop setlocal syntax=yaml
    autocmd BufNewFile,BufRead *.upf  setlocal syntax=tcl
augroup END

" allow absurd quantities of tabs
set tabpagemax=100

nnoremap <leader>d :put =strftime('%b %d, %Y')<CR>

vnoremap <leader>t :w !awk '{sum+=$NF} END{print sum}'<CR>

""""""""""""""""""""
" additions from framework; need to reorg and dedup

syntax on
set number
set relativenumber

" Use spaces instead of tabs
set expandtab
set shiftwidth=0      " Indentation width
set softtabstop=4     " Number of spaces a <Tab> counts for in insert mode
set tabstop=4         " Display tabs as 4 spaces

" Enable auto-indentation and smart indentation
set autoindent        " Copy indentation from the previous line
set smartindent       " Smart indentation for new lines
set smarttab          " Use shiftwidth when inserting a tab at the start of a line

set hlsearch
set tabpagemax=100

" Special case for Makefiles (actual tab characters required)
au FileType make set noexpandtab shiftwidth=8 softtabstop=8 tabstop=8

augroup Gemtext
  	autocmd!
  	autocmd BufRead,BufNewFile *.gmi setlocal spell wrap linebreak
augroup END

augroup Textfile
  	autocmd!
  	autocmd BufRead,BufNewFile *.txt setlocal spell wrap linebreak
augroup END

augroup KernelC
    autocmd!
    autocmd BufRead,BufNewFile *.c,*.h setlocal colorcolumn=80 noexpandtab softtabstop=8 tabstop=8
augroup END

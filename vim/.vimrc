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

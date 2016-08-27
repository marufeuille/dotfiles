if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

set nocompatible
syntax on
set background=dark
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
if has("autocmd")
  filetype plugin indent on
endif
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
set incsearch           " Incremental search
set autowrite           " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes) in terminals
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
set ambw=double
set ai
set ch=1
set nocp
set ci
set cuc
set cul
set enc=utf-8
set et
set fenc=utf-8
set fencs=utf-8,euc-jp-ms,cp932,iso-2022-jp
set ff=unix
set ffs=unix,dos,mac
set hls
set hi=1000
set ic
set is
set inf
set ls=2
set ml
set mouse=a
set nu
set nuw=4
set pi
set rs
set ru
set sr
set sw=4
set sc
set sm
set smd
set stal=2
set scs
set si
set sta
set sts=4
set ts=4
set tenc=utf-8
set top
set ul=1000
set vb
set wmnu
set so=2
set bs=indent,eol,start
set nowrap

filetype plugin indent on
set term=xterm-256color
syntax on
set number
set background=dark
set hlsearch
set incsearch
set autoindent

set shiftwidth=2
set softtabstop=2
set tabstop=2

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab

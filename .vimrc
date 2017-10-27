" this is very good docment
" https://www.slideshare.net/cohama/vim-script-vimrc-nagoyavim-1


"source ~/ijkl.vim
"source ~/jkl_.vim

command! -complete=mapping -nargs=* NXnoremap :nnoremap <args>| :xnoremap <args>

" noremap means no recursive map

" cursor
" NXnoremap i k
NXnoremap i k
NXnoremap j h
NXnoremap k j
NXnoremap l l
"noremap ; l

" appending
NXnoremap <C-l> A
inoremap <C-l> <esc>A
NXnoremap <C-e> A

" deleting
NXnoremap <BS> "_Xi
map h <BS>
nnoremap x "_x

" clever undo
inoremap <C-u> <esc>u

" jumping motion
NXnoremap v ge
NXnoremap V gE
NXnoremap ;a 0
NXnoremap ;s ^
NXnoremap ;e $
NXnoremap a 0
NXnoremap s ^
NXnoremap f $

" enable mouse
set mouse=a
set ttymouse=xterm2

nnoremap <C-m> i<C-m><esc>
set nocompatible
" this disabled with NXnoremap
set whichwrap=b,s,h,l,<,>,[,]
:set number

set laststatus=2
set statusline=%F%m%r%h%w
"\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]


NXnoremap <Space> v

NXnoremap _ :


" NXnoremap <M-x> :
NXnoremap <esc>x :

" toggle
NXnoremap <C-j> i
inoremap <C-j> <Nop>

NXnoremap <C-@> i
noremap! <C-@> <esc>

" NXnoremap <C-j> :echo "please press CTRL-Space"<CR>
" noremap! <C-j> <esc>:echo "please press CTRL-C"<CR>i
 
" insert
NXnoremap <C-k> i
NXnoremap ;i i

"noremap :: :
"noremap :; :
"map : ;
map ;j ;;
NXnoremap _ :


" quick commands
NXnoremap ;q :q<CR>
NXnoremap ;Q :q!
NXnoremap ;w :w<CR>
nnoremap ;t :tabnew<CR>

" reload file
"noremap ;r ???

" semi quick commands
nnoremap ;;q :qa<CR>
NXnoremap ;;r :source ~/.vimrc<C-m>
nmap ;;e ;t:edit ~/.vimrc<C-m>
NXnoremap ;;; ;

syntax enable

source ~/.vim/plugin.vim
set whichwrap=b,s,h,l,<,>,[,]
" source ~/.vim/jikken.vim



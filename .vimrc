" this is very good docment
" https://www.slideshare.net/cohama/vim-script-vimrc-nagoyavim-1


"source ~/ijkl.vim
"source ~/jkl_.vim

let mapleader = "\<space>"
map <Leader> <Nop>

command! -complete=mapping -nargs=* NXnoremap :nnoremap <args>| :xnoremap <args>
command! -complete=mapping -nargs=* NXmap :nmap <args>| :xmap <args>

" noremap means no recursive map

" cursor
" NXnoremap i k
NXnoremap i k
NXnoremap j h
NXnoremap k j
NXnoremap l l
"noremap <Leader> l

" appending
NXnoremap <C-l> A
inoremap <C-l> <esc>A
NXnoremap <C-e> A

" deleting
NXnoremap <BS> "_Xi
NXnoremap <C-h> "_X
NXmap h <C-h>
nnoremap x "_x

" clever undo
inoremap <C-u> <esc>u
noremap <C-u> u

" jumping motion
" NXnoremap v ge
" NXnoremap V gE
NXnoremap <Leader>a 0
NXnoremap <Leader>s ^
NXnoremap <Leader>e $
NXnoremap a 0
NXnoremap s ^
NXnoremap f $

" enable mouse
set mouse=a
set ttymouse=xterm2

" enter as new line on normal mode
nnoremap <CR> i<CR><esc>

" set commands
set nocompatible
" this disabled with NXnoremap
set whichwrap=b,s,h,l,<,>,[,]
:set number
set laststatus=2
set statusline=%F%m%r%h%w
"\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" enter visual mode
nnoremap <Leader>v v
xnoremap <Leader>v <esc>
NXnoremap <Leader>b <C-v>

"NXnoremap <M-x> :
NXnoremap <esc>x :

" NXnoremap <C-j> :echo "please press CTRL-Space"<CR>
" noremap! <C-j> <esc>:echo "please press CTRL-C"<CR>i
 
" insert
NXnoremap <C-j> i
inoremap <C-j> <Nop>
NXnoremap <Leader>i i

" append
NXnoremap <C-k> a
" overwritten by neosnippet binding
inoremap <C-k> <Right>

"alt <esc>
NXmap <C-@> <Leader>
noremap! <C-@> <esc>

"noremap :: :
"noremap :<Leader> :
"map : <Leader>
" map <Leader>j <Leader><Leader>
NXnoremap _ :


" quick commands
NXnoremap <Leader>q :q<CR>
NXnoremap <Leader>Q :q!
NXnoremap <Leader>w :w<CR>
nnoremap <Leader>t :tabnew<CR>

" reload file
"noremap <Leader>r ???

" semi quick commands
nnoremap <Leader><Leader>q :qa<CR>
NXnoremap <Leader><Leader>r :source ~/.vimrc<C-m>
nmap <Leader><Leader>e <Leader>t:edit ~/.vimrc<C-m>
" NXnoremap <Leader><Leader><Leader> <Leader>

syntax enable

" avoid tex conceal for neosnippet
" ref:
" https://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ""

source ~/.vim/plugin.vim
set whichwrap=b,s,h,l,<,>,[,]
" source ~/.vim/jikken.vim



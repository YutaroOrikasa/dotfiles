" neobundle settings {{{
if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    " vim からコマンド呼び出しているだけ neobundle.vim のクローン
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin - neobundle#end の間に導入するプラグインを記載

NeoBundle 'kana/vim-submode'
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'
" NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'ymatz/vim-latex-completion'
NeoBundle 'scrooloose/nerdcommenter'
" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on

let g:neocomplcache_enable_at_startup = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" 補完候補が表示されている場合は確定、そうでない場合は改行
" inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"


let g:neosnippet#snippets_directory='~/.vim/snippets/'

call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-') 
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+') 
call submode#leave_with('undo/redo', 'n', '', '<Esc>') 
call submode#map('undo/redo', 'n', '', '-', 'g-') 
call submode#map('undo/redo', 'n', '', '+', 'g+')


" Plugin key-mappings.
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <C-s>     <Plug>(neosnippet_expand_or_jump)
xmap <C-s>     <Plug>(neosnippet_expand_target)


" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
  endif

" 補完候補が表示されているときに、候補がスニペットなら展開し、
" そうでないなら補完候補を決定する
" 補完候補が表示されていないなら単にEnterを入力する
imap <expr><CR>
 \ pumvisible() ?
 \   neosnippet#expandable_or_jumpable() ?
 \     "\<Plug>(neosnippet_expand_or_jump)" 
 \     : neocomplcache#close_popup() 
 \  : "<CR>"

" inoremap <expr>1 "aaa"
" inoremap <expr>1  pumvisible() ? neocomplcache#close_popup() : "__CR__"
" imap <expr><CR>
"  \ pumvisible() ?
"  \   neosnippet#expandable_or_jumpable() ?
"  \     "\<Plug>(neosnippet_expand_target)or_jump)" 
"  \     : "1" 
"  \  : "1"
" 

imap <expr><C-g> neocomplcache#cancel_popup()


" NeoBundle 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'


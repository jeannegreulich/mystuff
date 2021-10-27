" size of a hard tabstop
set tabstop=2
" size of an "indent"
set shiftwidth=2
" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=2
set expandtab
set ruler
set pastetoggle=<F9>

" remove whitespace
map <F4> :%s/\s\+$//<cr>
" toggle spellcheck
map <F7> :set spell! spelllang=en_us spellfile=~/.vim/spellfile.add<cr>
:highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
" :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" " Try the following if your GUI uses a dark background.
" :highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
:match ExtraWhitespace /^\t*\zs \+$/
"
" Switch off :match highlighting.
:match
:autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
filetype plugin indent on


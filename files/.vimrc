" color scheme
"colorscheme distinguished
colorscheme badwolf
let g:badwolf_darkgutter = 1
"let g:badwolf_tabline = 0

" syntax processing
syntax enable

" set up tabs to be 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"set autoindent
"set smarttab

" set line numbers
set number

" show last command entered in the bottom bar
set showcmd

" highlight current line
set cursorline

" set up searching
set incsearch " search as characters are entered
set hlsearch " highlight matches

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
   if &wrap
      return "g" . a:movement
   else
      return a:movement
   endif
endfunction
noremap <silent> <expr> j ScreenMovement("j")
noremap <silent> <expr> k ScreenMovement("k")
noremap <silent> <expr> <Up> ScreenMovement("<Up>")
noremap <silent> <expr> <Down> ScreenMovement("<Down>")
"noremap <silent> <expr> 0 ScreenMovement("0")
"noremap <silent> <expr> ^ ScreenMovement("^")
"noremap <silent> <expr> $ ScreenMovement("$")
"nnoremap <silent> <Esc> <Esc>`^

" highlight parts of lines beyond 79 chars in Python files only (PEP-8 standard)
highlight OverLength ctermbg=red ctermfg=white cterm=bold guibg=#FFD9D9
au Filetype python match OverLength /\%>79v.\+/

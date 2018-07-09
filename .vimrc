set bg=light
syntax on

hi CursorLine   cterm=NONE ctermbg=darkgrey ctermfg=NONE guibg=white guifg=white

" When searching ignore cases and highlight the results
set hlsearch
set ignorecase

" Show matching brackets/parenthesis
set showmatch

" Give some offset to the vertical scrolling
set scrolloff=5

set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set showcmd
set modeline
set showmode                    " Display the current mode
set cursorline                  " Highlight current line

set tabstop=3
"set mouse=a
set t_Co=16



" Use Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required






filetype indent on

"map <C-J> <C-W>j<C-W>_
"map <C-K> <C-W>k<C-W>_
"map <C-L> <C-W>l<C-W>\|
"map <C-H> <C-W>h<C-W>\|
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h

map <f2> \di
map <f3> \ds

"set foldenable                  " Auto fold code
"set foldmethod=indent
"nmap <leader>f0 :set foldlevel=0<CR>
"nmap <leader>f1 :set foldlevel=1<CR>
"nmap <leader>f2 :set foldlevel=2<CR>
"nmap <leader>f3 :set foldlevel=3<CR>
"nmap <leader>f4 :set foldlevel=4<CR>
"nmap <leader>f5 :set foldlevel=5<CR>
"nmap <leader>f6 :set foldlevel=6<CR>
"nmap <leader>f7 :set foldlevel=7<CR>
"nmap <leader>f8 :set foldlevel=8<CR>
"nmap <leader>f9 :set foldlevel=9<CR>

" Persistent undo
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

"UPPERCASE and lowsercase conversion
nnoremap g^ gUiW
nnoremap gv guiW

" Only when working with gvim
"set keywordprg=man\ -P\ more

au BufRead,BufNewFile *.html,*.txt,README,*.rst set textwidth=80
au BufRead,BufNewFile *.tex,*.rst,COMMIT_EDITMSG set spell spelllang=en
au BufRead,BufNewFile *.midl,*.pidl set syntax=idl
au BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.java,*.py,*.f90,*.F90,*.tex,CMakeLists.txt,*.sh set number numberwidth=1
au BufNewFile,BufRead *.cl	set syntax=opencl

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG set textwidth=80
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Easier codying in python
au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab nosmartindent

" For marking trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()

" Jump to the last cursor position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif


if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
endif

" Run ctags with F12
map <f12> :!ctags -R .<cr>

" go to defn of tag under the cursor, case sensitive
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    finally
       let &ic = ic
    endtry
endfun
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

nmap <F8> :TagbarToggle<CR>

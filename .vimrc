
" Generic useful options
syntax on
set hlsearch                    " highlight all search results
set ignorecase                  " case insensitive searching
set showmatch                   " Show matching brackets/parenthesis
set scrolloff=5                 " Leave 5 lines of offset when scrolling through a window
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set showcmd                     " Display the current command
set showmode                    " Display the current mode
set cursorline                  " Highlight current line
set modeline

set tabstop=3
"set mouse=a

" ==================================================================================
" Vundle plugins
"
" To get Vundle going, do the following
"
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
" To get a plugin use :PluginInstall. E.g.:
"
" :PluginInstall bling/vim-airline
"
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
" Colorschemes
Plugin 'jacoborus/tender.vim'
Plugin 'sjl/badwolf'
Plugin 'gosukiwi/vim-atom-dark'
call vundle#end()            " required
filetype plugin indent on    " required
" ==================================================================================


colorscheme tender
filetype indent on

" Easier navigation through windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h

" Draw It start, stop
map <f2> \di
map <f3> \ds

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
au BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.tcc,*.c.in,*.h.in,*.cc.in,*.cpp.in,*.R,*.java,*.py,*.f90,*.F90,*.tex,CMakeLists.txt,*.sh,*.yml,*cmake,*rst set number numberwidth=1 list listchars=tab:>-,trail:.,extends:>,precedes:<
au BufNewFile,BufRead *.cl	set syntax=opencl

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG set textwidth=80
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Easier codying in python
au FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab nosmartindent

" Mark trailing whitespaces
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

" Run ctags
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

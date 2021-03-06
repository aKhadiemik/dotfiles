" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50    " keep 50 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " turn syntax highlighting on all the friggin' time;
  " that way, chars > 80 get highlighted always
  autocmd BufRead,BufNewFile * :syntax on
else

  set autoindent " always set autoindenting on

endif " has("autocmd")

if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=2
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '

  " automatically open folds at the starting cursor position
  " autocmd BufReadPost .foldo!
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
set laststatus=2

nmap <F1> <Esc> " No help

set list listchars=tab:»·,trail:·

" Color scheme
colorscheme github

" Numbers
set number
set numberwidth=5

" Words
set gdefault
set shiftround

" GUI
set guioptions-=T
set guioptions-=r
set guioptions-=L

set gfn=Bitstream\ Vera\ Sans\ Mono:h24
set clipboard=unnamed

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu,preview
set complete=.,w,b,u,t
set wildmode=list:longest,list:full

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Edit routes
command! Rroutes :Redit config/routes.rb
command! RTroutes :RTedit config/routes.rb

" Edit factories
command! Rfactories :Redit spec/factories.rb
command! RTfactories :RTedit spec/factories.rb

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" \ is the leader character
let mapleader = "\\"

" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>

" Leader shortcuts for Rails commands
map <Leader>m :Rmodel
map <Leader>c :Rcontroller
map <Leader>v :Rview
map <Leader>tm :RTmodel
map <Leader>tc :RTcontroller
map <Leader>tv :RTview

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Maps autocomplete to tab
imap <Tab> <C-N>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" because escape is too far away
imap jj <ESC>

" Custom settings / bindings
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>x :bd<CR>
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
map <silent> <C-h> ^cw

" Session management
nmap <F2> :mksession! ~/.vim_session <CR> " Quick write session with F2
nmap <F3> :source ~/.vim_session <CR>     " And load session with F3

vmap <buffer> <C-T> !alphabetize<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

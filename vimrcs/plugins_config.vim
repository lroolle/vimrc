"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h')."/.."
call pathogen#infect(s:vim_runtime.'/sources_forked/{}')
call pathogen#infect(s:vim_runtime.'/sources_non_forked/{}')
call pathogen#infect(s:vim_runtime.'/my_plugins/{}')
call pathogen#helptags()


"""""""""""""""""""""""""""""
" updatetime
"""""""""""""""""""""""""""""
autocmd BufEnter *.py set updatetime=100

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


""""""""""""""""""""""""""""""
" => YankStack
""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

"nmap <c-p> <Plug>yankstack_substitute_older_paste
"nmap <c-n> <Plug>yankstack_substitute_newer_paste

nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>n <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'


""""""""""""""""""""""""""""""
" => ZenCoding
""""""""""""""""""""""""""""""
" Enable all functions in all modes
let g:user_zen_mode='a'


""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize = 35
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''

map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/majutsushi/tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>tt :TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_foldlevel = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTreeToggle combined with TagbarToggle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:ToggleNERDTreeAndTagbar()
    if exists('g:tagbar_left')
        let s:tagbar_left_user = g:tagbar_left
    else
        let s:tagbar_left_user = 0
    endif

    if exists('g:tagbar_vertical')
        let s:tagbar_vertical_user = g:tagbar_vertical
    else
        let s:tagbar_vertical_user = 0
    endif

    " settings required for split window nerdtree / tagbar
    let g:NERDTreeWinSize = max([g:tagbar_width, g:NERDTreeWinSize])
    let g:tagbar_left = 0
    let g:tagbar_vertical = winheight(0)/2

    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let s:nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
    else
        let s:nerdtree_open = 0
    endif
    let s:tagbar_open = bufwinnr('__Tagbar__') != -1

    " toggle tagbar & NERDTree
    if s:nerdtree_open && s:tagbar_open
        NERDTreeClose
        TagbarClose
    else
        if s:nerdtree_open
            NERDTreeClose
        elseif s:tagbar_open
            TagbarClose
        endif

        " remember buffer (actually, this is a hack, not sure if there is a
        " good way to do this)
        let b:NERDTreeAndTagbar_come_back_to_me = 1

        " open tagbar as split of nerdtree window
        "TagbarOpen |
        NERDTree | TagbarOpen

        " go back to initial buffer
        while !exists('b:NERDTreeAndTagbar_come_back_to_me')
            wincmd w
        endwhile
        unlet b:NERDTreeAndTagbar_come_back_to_me
    endif

    " reset default / user configuration of tagbar
    let g:tagbar_left = s:tagbar_left_user
    let g:tagbar_vertical = s:tagbar_vertical_user
endfunction

command! -nargs=0 ToggleNERDTreeAndTagbar :call s:ToggleNERDTreeAndTagbar()
map <leader>nb :ToggleNERDTreeAndTagbar<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:multi_cursor_next_key="\<C-s>"

let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    call youcompleteme#DisableCursorMovedAutocommands()
    let b:deoplete_disable_auto_complete=1
endfunction

function! Multiple_cursors_after()
    call youcompleteme#EnableCursorMovedAutocommands()
    let b:deoplete_disable_auto_complete=0
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }

let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ ['mode', 'paste'],
            \             ['fugitive', 'readonly', 'tagbar', 'modified'] ],
            \   'right': [ [ 'lineinfo' ], ['percent'] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
            \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
            \   'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}'
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
            \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
            \ },
            \ 'separator': { 'left': ' ', 'right': ' ' },
            \ 'subseparator': { 'left': ' ', 'right': ' ' }
            \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimroom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 1
let g:goyo_margin_bottom = 1
nnoremap <silent> <leader>z :Goyo<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_fmt_command = "goimports"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
" => https://github.com/nvie/vim-flake8
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:syntastic_check_on_open = 1

let g:syntastic_python_checkers=['pyflakes']

" Javascript
let g:syntastic_javascript_checkers = ['jshint']

" Go
let g:syntastic_auto_loc_list = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Custom CoffeeScript SyntasticCheck
func! SyntasticCheckCoffeescript()
    let l:filename = substitute(expand("%:p"), '\(\w\+\)\.coffee', '.coffee.\1.js', '')
    execute "tabedit " . l:filename
    execute "SyntasticCheck"
    execute "Errors"
endfunc
nnoremap <silent> <leader>c :lclose<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/Valloric/MatchTagAlways
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap % :MtaJumpToOtherTag<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/Valloric/YouCompleteMe#user-guide
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ycm_key_list_select_completion = ['<C-j>', '<Down>', '<Tab>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>', '<S-Tab>']
let g:ycm_autoclose_preview_window_after_completion=1
"map <F4>:YcmCompleter GoToDefinitionElseDeclaration<CR>

nnoremap <leader>] : YcmCompleter GoTo<CR>
nnoremap <leader>i : YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>; : YcmCompleter GoToReferences<CR>

" Let YCM read tags from Ctags file
let g:ycm_collect_identifiers_from_tags_files = 1
" Default 1, just ensure
let g:ycm_use_ultisnips_completer = 1
" Completion for programming language's keyword
let g:ycm_seed_identifiers_with_syntax = 1
" Completion in comments
let g:ycm_complete_in_comments = 1
" Completion in string
let g:ycm_complete_in_strings = 1

" 注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0
" Stop asking once per .ycm_extra_conf.py file if it is safe to be loaded
let g:ycm_confirm_extra_conf = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/altercation/vim-colors-solarized
" => https://github.com/iCyMind/NeoSolarized
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set background=dark
hi Visual term=reverse cterm=reverse guibg=Grey

"" Terminal color conflict with vim solarized
"let g:solarized_termcolors=256
"
"set t_Co=256
"colorscheme NeoSolarized



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/SirVer/ultisnips
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/Chiel92/vim-autoformat
" pep8 requirements
" $ sudo apt-get install python-autopep8
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <c-s-l> :Autoformat<CR>


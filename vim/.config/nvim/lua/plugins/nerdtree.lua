vim.cmd[[
" If NEDRTree is open toggle focus
function! ToogleFocusCloseNerdTree()
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        " IF NERD TREE IS OPEN

        if bufname("") == (t:NERDTreeBufName)
            " IF CURSOR IS IN NERD TREE WINDOW
            call feedkeys("\<c-w>\<c-p>")
        else
            " IF CURSOR IS IN WIDOW
            silent NERDTreeFocus
        endif
    else
        " IF NERD TREE IS CLOSED
            " silent NERDTreeTabsOpen " can by annoying when you have many tabs open
        silent NERDTree
            " bug: NERDTreeTabsFind need to by fixed in this scenario
        " silent NERDTreeFocus
        " silent NERDTreeTabsFind
    endif
endfunction

" F2 to open/close sidebar with folders/files
map <silent> <F2> :call ToogleFocusCloseNerdTree()<cr>
map <silent> <leader><F2> :NERDTreeTabsClose<cr>
map <silent> <F3> :NERDTreeTabsFind<cr>

let NERDTreeMapOpenSplit      = 's'
let NERDTreeMapOpenVSplit     = 'v'
let NERDTreeMapPreviewSplit   = 'ps'
let NERDTreeMapPreviewVSplit  = 'pv'

let NERDTreeWinSize = 44
let NERDTreeShowHidden=0
let NERDTreeMinimalUI=1
let NERDTreeShowLineNumbers=0
let NERDTreeAutoDeleteBuffer=1
let g:nerdtree_tabs_open_on_gui_startup = 0 " Open NERDTree on gvim/macvim startup (1)
let g:nerdtree_tabs_open_on_console_startup = 0 " Open NERDTree on console vim startup (0)
let g:nerdtree_tabs_no_startup_for_diff = 1 " Do not open NERDTree if vim starts in diff mode (1)
let g:nerdtree_tabs_smart_startup_focus = 1 " On startup - focus NERDTree when opening a directory, focus the file if editing a specified file. When set to `2`, always focus file after startup. (1)
let g:nerdtree_tabs_open_on_new_tab = 1 " Open NERDTree on new tab creation (if NERDTree was globally opened by :NERDTreeTabsToggle) (1)
let g:nerdtree_tabs_meaningful_tab_names = 1 " Unfocus NERDTree when leaving a tab for descriptive tab names (1)
let g:nerdtree_tabs_autoclose = 1 " Close current tab if there is only one window in it and it's NERDTree (1) 
let g:nerdtree_tabs_synchronize_view = 1 " Synchronize view of all NERDTree windows (scroll and cursor position) (1) 
let g:nerdtree_tabs_synchronize_focus = 1 " Synchronize focus when switching tabs (focus NERDTree after tab switch if and only if it was focused before tab switch) (1) 
let g:nerdtree_tabs_focus_on_files = 1 " When switching into a tab, make sure that focus is on the file window, not in the NERDTree window. (Note that this can get annoying if you use NERDTree's feature 'open in new tab silently', as you will lose focus on the NERDTree.) (0) 

" If vim opened empty open NERDTree
" if empty(argv())
"   au VimEnter * NERDTreeTabsOpen
" endif



" NERDTree-git-plugin
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \ }
]]

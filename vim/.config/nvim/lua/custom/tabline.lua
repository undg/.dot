vim.cmd[[
hi! TAB_BAR_BG     guifg=#5f5f5f guibg=#a8a8a8 cterm=none gui=none ctermfg=59 ctermbg=100
hi! TAB_BG         guifg=#5f5f5f guibg=#c8c8c8 cterm=none gui=none ctermfg=59 ctermbg=100
hi! TAB_ACTIVE_BG  guifg=#5f5f5f guibg=#ffaf00 cterm=none gui=none ctermfg=59 ctermbg=214

function! Tabline()
    let tabBarStr = ''
    let tabBarStr .= '%#TAB_BAR_BG# '
    for i in range(tabpagenr('$'))
        let tabNr = i + 1
        let winNr = tabpagewinnr(tabNr)
        let bufList = tabpagebuflist(tabNr)
        let bufNr = bufList[winNr - 1]
        let bufName = bufname(bufNr)
        let bufModified = getbufvar(bufNr, "&mod")

        " initialise tab title background
        let tabBarStr .= (tabNr == tabpagenr() ? '%#TAB_ACTIVE_BG# ' : '%#TAB_BG# ')
        " tab number with apostrophe
        let tabBarStr .= tabNr .'°'
        " file/buffer name
        let tabBarStr .= (bufName != '' ? fnamemodify(bufName, ':t')  : '[No Name]') 
        " saved status
        let tabBarStr .= bufModified ? '[+]' : ''
        " restore tab bar background
        let tabBarStr .= ' %#TAB_BAR_BG# '
    endfor

    let tabBarStr .= '%#TAB_BAR_BG#'
    if (exists("g:tablineclosebutton"))
        let tabBarStr .= '%=%999XX'
    endif
    return tabBarStr
endfunction

set tabline=%!Tabline()
]]

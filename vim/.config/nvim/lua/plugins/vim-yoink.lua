local map = require('utils.map')

map.normal('p', '<Plug>(YoinkPaste_p)', {noremap = false, silent = false})
map.normal('P', '<Plug>(YoinkPaste_P)', {noremap = false, silent = false})

map.normal('<Leader>n', '<Plug>(YoinkPostPasteSwapBack)', {noremap = false, silent = false})
map.normal('<Leader>N', '<Plug>(YoinkPostPasteSwapForward)', {noremap = false, silent = false})

map.normal('[y', '<plug>(YoinkRotateBack)', {noremap = false, silent = false})
map.normal(']y', '<plug>(YoinkRotateForward)', {noremap = false, silent = false})

-- History size. Default: 10.
vim.g.yoinkMaxItems = 10

-- When set to 1, every time the yank history changes the numbered registers 1 - 9 will be updated to sync with the first 9 entries in the yank history. See here for an explanation of why we would want do do this. Default: 0.
vim.g.yoinkSyncNumberedRegisters = 0

-- When set to 1, delete operations such as x or d or s will also be added to the yank history. Default: 0
vim.g.yoinkIncludeDeleteOperations = 1

-- When set to 1, the yank history will be saved persistently across sessions of Vim. Note: Requires Neovim. See here for details. Default: 0
vim.g.yoinkSavePersistently = 1

-- When set to 1, after a paste occurs it will automatically be formatted (using = key). Default: 0. Note that you can also leave this off and use the toggle key instead for cases where you want to format after the paste.
vim.g.yoinkAutoFormatPaste = 0

-- When set to 1, the cursor will always be placed at the end of the paste. Default is 0 which will match normal Vim behaviour and place the cursor at the beginning when pasting multiline yanks. Setting to 1 can be nicer because it makes the post-paste cursor position more consistent between multiline and non-multiline pastes (that is, the cursor will be at the end in both cases). And also causes consecutive multiline pastes to be ordered correctly instead of interleaved together. Will also add to the jumplist if the cursor is moved more than 1 line.
vim.g.yoinkMoveCursorToEndOfPaste = 1

-- When set to 1, when we reach the beginning or end of the yank history, the swap will stop there. When set to 0, it will cycle back to the other end of the history so you can swap in the same direction forever. Default: 1
vim.g.yoinkSwapClampAtEnds = 1

-- When set to 1, all yanks for all registers will be included in the history. When set to 0, only changes to the default register will be recorded. Default: 1
vim.g.yoinkIncludeNamedRegisters = 1

 -- When set to 0, the System Clipboard feature. Default: 1
vim.g.yoinkSyncSystemClipboardOnFocus = 1


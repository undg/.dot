local map = require('utils.map')

map.normal('p', '<Plug>(YoinkPaste_p)', {noremap = false, silent = false})
map.normal('P', '<Plug>(YoinkPaste_P)', {noremap = false, silent = false})

map.normal('<Leader>n', '<Plug>(YoinkPostPasteSwapBack)', {noremap = false, silent = false})
map.normal('<Leader>N', '<Plug>(YoinkPostPasteSwapForward)', {noremap = false, silent = false})

map.normal('[y', '<plug>(YoinkRotateBack)', {noremap = false, silent = false})
map.normal(']y', '<plug>(YoinkRotateForward)', {noremap = false, silent = false})



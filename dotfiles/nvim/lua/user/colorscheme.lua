local colorscheme = "nord"

vim.g.nord_borders = true
vim.g.nord_italic = false
vim.g.nord_contrast = true

local status_okay, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_okay then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end

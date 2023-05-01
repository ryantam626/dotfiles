local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup {
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "",
      }
    },
    show_close_icon = false,
    show_buffer_close_icons = false,
  },
  highlights = {
    buffer_selected = {
      bold = true,
      italic = false,
    },
  }
}

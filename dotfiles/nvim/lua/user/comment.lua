local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end

comment.setup {
  toggler = {
    ---Line-comment toggle keymap
    line = '<C-_>',
    ---Block-comment toggle keymap
    block = 'gbc',
  },
  opleader = {
    ---Line-comment keymap
    line = '<C-_>',
    ---Block-comment keymap
    block = 'gb',
  },

  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

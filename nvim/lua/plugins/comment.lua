-- https://github.com/numToStr/Comment.nvim
-- "gc" to comment visual regions/lines_str
return { 'numToStr/Comment.nvim', event = { 'BufRead', 'BufWinEnter' }, cmd = { 'CommentToggle' }, keys = { 'gc', 'gcc', 'gbc' }, opts = {} }

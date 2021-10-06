-- [ ] live grep remember last search
-- [X] warn when closing with unsaved file (autosave)
-- [X] tab dont insert tab
-- [X] copy paste system dont work
-- [ ] add session system to restore the previous session ?
-- [ ] auto reload when file is updated externaly
-- [X] copy paste dont work on VimTree etc (maybe use ctrl+v) (use ctrl+r)
-- [X] delete word $toto should delete $toto and not only $ (use df<char>)
-- [X] téléscope dont find hidden files (.env)
-- [ ] copy file cross nvim
-- [X] show visual tab character

-------------------- HELPERS -------------------------------

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--------------------- INIT ---------------------------------

-- path is used in other file and should not be local
path_intelephense = fn.stdpath('data') .. '/site/pack/intelephense'
if fn.executable('npm') == 0 then
  print("ERROR `npm` executable not found.")
elseif fn.isdirectory(path_intelephense) == 0 then
  fn.system({'npm', 'install', '--progress', '--prefix=' .. path_intelephense, 'intelephense'})
end

local path_packer = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
require('plugin')
if fn.isdirectory(path_packer) == 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', path_packer})
  cmd 'packadd packer.nvim'
  cmd "autocmd User PackerComplete ++once lua require('setup')"
  require('packer').sync()
else
  require('setup')
end

-------------------- OPTIONS -------------------------------

opt.title = true                    -- Set nvim title to filename
vim.o.guifont = 'FiraCode Nerd Font Mono:h12'
opt.list = true
opt.listchars = {tab='▷ ', trail='·', extends='…', precedes='…', nbsp='○'}
opt.completeopt = {'menuone', 'noselect'}  -- Completion options
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.signcolumn = 'yes'              -- Show sign column
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 2                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wrap = false                    -- Disable line wrap
opt.swapfile = false  -- todo swap seems dont work ?
--opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,resize,winpos,terminal"
g.mapleader=' '
g.surround_no_mappings = true

-------------------- MAPPINGS ------------------------------

map('', '<C-c>', '"+y')           -- Copy to clipboard
map('', '<C-v>', '"+p')           -- Paste from clipboard
map('i', '<C-y<ESC>A', '"+y')     -- Copy to clipboard
map('i', '<C-p<ESC>A', '"+p')     -- Paste from clipboard
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

map('', 'c', 'h', { noremap = true }) -- left
map('', 'r', 'l', { noremap = true }) -- right
map('', 't', 'j', { noremap = true }) -- up
map('', 's', 'k', { noremap = true }) -- down
map('', 'k', 's', { noremap = true }) -- replace single character
map('', 'j', 't', { noremap = true }) -- replace single character
map('', 'l', 'r', { noremap = true }) -- replace single character
map('', 'h', 'c', { noremap = true }) -- replace single character
map('n', '<C-t>', '<C-d>', { noremap = true }) -- 1/2 page down
map('n', '<C-s>', '<C-u>', { noremap = true }) -- 1/2 page up
map('n', 'ga', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
map('n', 'gi', "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>")
map('n', 'gh', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>")
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', 'gm', "<cmd>lua require('lspsaga.rename').rename()<CR>")
--map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'éf', "<cmd>lua require('telescope.builtin').find_files()<CR>")
map('n', 'ég', "<cmd>lua require('telescope.builtin').live_grep()<CR>")
map('n', 'éb', "<cmd>lua require('telescope.builtin').buffers()<CR>")
map('n', 'éh', "<cmd>lua require('telescope.builtin').help_tags()<CR>")
--map('', '<leader><leader>', ':HopWord<CR>')
map('', '<leader>q', ':wq<CR>')
map('', '<leader>w', ':w<CR>')

-- <Tab> to navigate the completion menu
map('i', '<C-t>', 'pumvisible() ? "\\<C-p>" : "\\<C-t>"', {expr = true})
map('i', '<C-s>', 'pumvisible() ? "\\<C-n>" : "\\<C-s>"', {expr = true})
map('i', '<C-space>', "compe#confirm({'keys': '<CR>', 'select': v:true})", {silent = true, expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

map('', '<leader>t', ':bprev<CR>')
map('', '<leader>s', ':bnext<CR>')
map('', '<leader>bd', ':bd<CR>')

map('n', '<leader>pt', ':NvimTreeToggle<CR>')
map('n', '<leader>pf', ':NvimTreeFindFile<CR>')
map('n', '<leader>pp', ':NvimTreeFocus<CR>')

-------------------- NEOVIDE -------------------------------

g.neovide_remember_window_size = true
g.neovide_cursor_antialiasing = true

-------------------- COMMANDS ------------------------------

cmd[[autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}]]
cmd[[autocmd FileType php setlocal shiftwidth=4 softtabstop=4]] -- php indent 4 spaces
cmd[[autocmd BufWritePre * :%s/\s\+$//e]] -- trim trailing space on save
cmd[[autocmd BufNewFile,BufRead Jenkinsfile setf groovy]]

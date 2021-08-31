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
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

local install_path = fn.stdpath('data') .. '/site/pack/phpactor'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/phpactor/phpactor.git', install_path})
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'                  -- load the package manager
local paq = require('paq-nvim').paq     -- a convenient alias
paq {'savq/paq-nvim', opt = true}       -- paq-nvim manages itself
paq {'nvim-lua/completion-nvim'}        -- autocompletion
paq {'nvim-treesitter/nvim-treesitter'} -- syntax color
paq {'neovim/nvim-lspconfig'}           -- lsp to config server
paq {'nvim-lua/plenary.nvim'}           -- dependency of telescope
paq {'nvim-telescope/telescope.nvim'}   -- jump to file
paq {'phaazon/hop.nvim'}                -- jump anywhere
paq {'tpope/vim-surround'}              -- surround text
paq {'tpope/vim-commentary'}            -- add commentary
paq {'kyazdani42/nvim-web-devicons'}    -- dependency of nvim-tree
paq {'kyazdani42/nvim-tree.lua'}        -- file tree
paq {'akinsho/nvim-bufferline.lua'}     -- buffer design

-------------------- COLORSCHEME ---------------------------
paq {'sainnhe/edge'}
paq {'codicocodes/tokyonight.nvim'}
g.tokyonight_style='storm'
g.colors_name='tokyonight'
g.tokyonight_transparent=true
g.tokyonight_dark_sidebar=false
g.tokyonight_transparent_sidebar=true

-------------------- OPTIONS -------------------------------
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
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
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap

-------------------- MAPPINGS ------------------------------
map('', '<leader>c', '"+y')       -- Copy to clipboard in normal, visual, select and operator modes
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

-- <Tab> to navigate the completion menu
map('i', '<C-t>', 'pumvisible() ? "\\<C-p>" : "\\<C-t>"', {expr = true})
map('i', '<C-s>', 'pumvisible() ? "\\<C-n>" : "\\<C-s>"', {expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- BUFFER --------------------------------
local bl = require 'bufferline'
bl.setup{
    options = {
      view = "multiwindow",
      numbers = function(opts) 
        return string.format('%s', opts.raise(opts.ordinal))
      end,
      modified_icon = '●',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 18,
      max_prefix_length = 25, -- prefix used when a buffer is deduplicated
      tab_size = 20,
      diagnostics ="nvim_lsp",
      show_buffer_close_icons = false,
      show_close_icon = false,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and "" or ""
        return " " .. icon .. count
      end,
      separator_style = "thin",
    }
  }

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'

-- We use the default settings for gopls and ...
lsp.gopls.setup{on_attach=require'completion'.on_attach}
lsp.phpactor.setup{on_attach=require'completion'.on_attach}

map('n', 't', 'h', { noremap = true })
map('n', 's', 'j', { noremap = true })
map('n', 'r', 'k', { noremap = true })
map('n', 'n', 'l', { noremap = true })
map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', '<space>éf', "<cmd>lua require('telescope.builtin').find_files()<CR>")
map('n', '<space>ég', "<cmd>lua require('telescope.builtin').live_grep()<CR>")
map('n', '<space>éb', "<cmd>lua require('telescope.builtin').buffers()<CR>")
map('n', '<space>éh', "<cmd>lua require('telescope.builtin').help_tags()<CR>")
map('', '<space><space>', ':HopWord<CR>')
map('n', '<space>pt', ':NvimTreeToggle<CR>')
map('n', '<space>pf', ':NvimTreeFindFile<CR>')
map('', '<space>t', ':bprev<CR>')
map('', '<space>s', ':bnext<CR>')
map('', '<space>bd', ':bd<CR>')
map('', '<space>q', ':wq<CR>')
map('', '<space>w', ':w<CR>')

-------------------- COMMANDS ------------------------------
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'  
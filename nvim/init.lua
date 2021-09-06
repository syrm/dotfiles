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

local path_paq = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.executable('git') == 0 then
  print("ERROR `git` executable not found.")
elseif fn.isdirectory(path_paq) == 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', path_paq})
end

local path_intelephense = fn.stdpath('data') .. '/site/pack/intelephense'
if fn.executable('npm') == 0 then
  print("ERROR `npm` executable not found.")
elseif fn.isdirectory(path_intelephense) == 0 then
  fn.system({'npm', 'install', '--progress', '--prefix=' .. path_intelephense, 'intelephense'})
end

-------------------- PLUGINS -------------------------------

cmd 'packadd paq-nvim'                  -- load the package manager
local paq = require('paq-nvim').paq     -- a convenient alias
paq {'savq/paq-nvim', opt = true}       -- paq-nvim manages itself
paq {'hrsh7th/nvim-compe'}              -- autocompletion
paq {'nvim-treesitter/nvim-treesitter'} -- syntax color
paq {'neovim/nvim-lspconfig'}           -- lsp to config server
paq {'nvim-lua/plenary.nvim'}           -- dependency of telescope
paq {'nvim-telescope/telescope.nvim'}   -- jump to file
paq {'phaazon/hop.nvim'}                -- jump anywhere
paq {'windwp/nvim-autopairs'}           -- auto pair brackets
paq {'tpope/vim-surround'}              -- surround text
paq {'tpope/vim-commentary'}            -- add commentary
paq {'kyazdani42/nvim-web-devicons'}    -- dependency of nvim-tree
paq {'kyazdani42/nvim-tree.lua'}        -- file tree
paq {'akinsho/nvim-bufferline.lua'}     -- buffer design
-- paq {'kosayoda/nvim-lightbulb'}         -- add lightbulb for codeAction # TODO does it work ?
paq {'nvim-lua/popup.nvim'}             -- dependency of lspsaga
paq {'glepnir/lspsaga.nvim'}            -- lsp ui # TODO codeAction seems dont work
paq {'glepnir/galaxyline.nvim'}         -- statusline

-------------------- COLORSCHEME ---------------------------

paq {'sainnhe/edge'}
paq {'codicocodes/tokyonight.nvim'}
g.tokyonight_style='storm'
g.colors_name='tokyonight'
g.tokyonight_transparent=true
g.tokyonight_dark_sidebar=false
g.tokyonight_transparent_sidebar=true

-------------------- OPTIONS -------------------------------

opt.completeopt = {'menuone', 'noselect'}  -- Completion options
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = false                    -- Show some invisible characters
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
opt.swapfile = false
g.mapleader=' '
g.surround_no_mappings = true

-------------------- MAPPINGS ------------------------------

map('', '<leader>c', '"+y')       -- Copy to clipboard
map('', '<leader>v', '"+p')       -- Paste from clipboard
map('i', '<C-u>', '<C-g>u<C-u>')  -- Make <C-u> undo-friendly
map('i', '<C-w>', '<C-g>u<C-w>')  -- Make <C-w> undo-friendly

map('', 'c', 'h', { noremap = true }) -- left
map('', 'r', 'l', { noremap = true }) -- right
map('', 't', 'j', { noremap = true }) -- up
map('', 's', 'k', { noremap = true }) -- down
map('', 'k', 'r', { noremap = true }) -- replace single character
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
map('', '<leader><leader>', ':HopWord<CR>')
map('', '<leader>q', ':wq<CR>')
map('', '<leader>w', ':w<CR>')

-- <Tab> to navigate the completion menu
map('i', '<C-t>', 'pumvisible() ? "\\<C-p>" : "\\<C-t>"', {expr = true})
map('i', '<C-s>', 'pumvisible() ? "\\<C-n>" : "\\<C-s>"', {expr = true})
map('i', '<Tab>', "compe#confirm({'keys': '<CR>', 'select': v:true})", {silent = true, expr = true})

map('n', '<C-l>', '<cmd>noh<CR>')    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``')  -- Insert a newline in normal mode

map('', '<leader>t', ':bprev<CR>')
map('', '<leader>s', ':bnext<CR>')
map('', '<leader>bd', ':bd<CR>')

map('n', '<leader>pt', ':NvimTreeToggle<CR>')
map('n', '<leader>pf', ':NvimTreeFindFile<CR>')
map('n', '<leader>pp', ':NvimTreeFocus<CR>')

-------------------- COMPLETION ----------------------------

local cmp = require('compe')
cmp.setup {
  enabled = true,
  autocomplete = true,
  preselect = 'enable',
  min_length = 2,
  documentation = {
    border = 'solid',
    winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder'
  },
  source = {
    path = true,
    buffer = {
      priority = 1
    },
    nvim_lua = true,
    nvim_lsp = {
      enable = true,
      priority = 100
    }
  }
}

-------------------- TELESCOPE -----------------------------

local telescope = require('telescope')
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-n>'] = false,
        ['<C-p>'] = false,
        ['j'] = false,
        ['k'] = false,
        ['<C-t>'] = require('telescope.actions').move_selection_next,
        ['<C-s>'] = require('telescope.actions').move_selection_previous,
        ['qq'] = require('telescope.actions').close
      },
      n = {
        ['qq'] = require('telescope.actions').close
      },
    }
  }
}

-------------------- AUTOPAIRS -----------------------------

local autopairs = require('nvim-autopairs')
autopairs.setup {}

-------------------- TREE-SITTER ---------------------------

local ts = require('nvim-treesitter.configs')
ts.setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  indent = {enable = true}
}

-------------------- BUFFER --------------------------------

local bl = require('bufferline')
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

-------------------- NVIMTREE ------------------------------

local tree_cb = require('nvim-tree.config').nvim_tree_callback

g.nvim_tree_disable_default_keybindings = 1
g.nvim_tree_root_folder_modifier = ':t'
g.nvim_tree_bindings = {
  { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
  { key = {"<2-RightMouse>", "<C-]>"},    cb = tree_cb("cd") },
  { key = "<C-v>",                        cb = tree_cb("vsplit") },
  { key = "<C-x>",                        cb = tree_cb("split") },
  { key = "<C-t>",                        cb = tree_cb("tabnew") },
  { key = "<",                            cb = tree_cb("prev_sibling") },
  { key = ">",                            cb = tree_cb("next_sibling") },
  { key = "P",                            cb = tree_cb("parent_node") },
  { key = "<BS>",                         cb = tree_cb("close_node") },
  { key = "<S-CR>",                       cb = tree_cb("close_node") },
  { key = "<Tab>",                        cb = tree_cb("preview") },
  { key = "K",                            cb = tree_cb("first_sibling") },
  { key = "J",                            cb = tree_cb("last_sibling") },
  { key = "I",                            cb = tree_cb("toggle_ignored") },
  { key = "H",                            cb = tree_cb("toggle_dotfiles") },
  { key = "R",                            cb = tree_cb("refresh") },
  { key = "a",                            cb = tree_cb("create") },
  { key = "d",                            cb = tree_cb("remove") },
  { key = "r",                            cb = tree_cb("rename") },
  { key = "<C-r>",                        cb = tree_cb("full_rename") },
  { key = "x",                            cb = tree_cb("cut") },
  { key = "c",                            cb = tree_cb("copy") },
  { key = "p",                            cb = tree_cb("paste") },
  { key = "y",                            cb = tree_cb("copy_name") },
  { key = "Y",                            cb = tree_cb("copy_path") },
  { key = "gy",                           cb = tree_cb("copy_absolute_path") },
  { key = "[c",                           cb = tree_cb("prev_git_item") },
  { key = "]c",                           cb = tree_cb("next_git_item") },
  { key = "-",                            cb = tree_cb("dir_up") },
  { key = "o",                            cb = tree_cb("system_open") },
  { key = "q",                            cb = tree_cb("close") },
}

-------------------- LSP -----------------------------------
local lsp = require('lspconfig')

lsp.gopls.setup { on_attach = require('completion').on_attach }

local command_intelephense = path_intelephense .. '/node_modules/.bin/intelephense'
if fn.executable(command_intelephense .. '.cmd') ~= 0 then
  command_intelephense = command_intelephense .. '.cmd'
end

lsp.intelephense.setup {
  cmd = { command_intelephense, '--stdio' },
  filetypes = { 'php' },
  init_options = {
    licenceKey = fn.stdpath('data') .. '/intelephense.licence',
  },
  on_attach = require('completion').on_attach,
}

vim.g.completion_matching_strategy_list = {'substring', 'exact', 'fuzzy', 'all'}
vim.g.completion_chain_complete_list = {
  {complete_itemns = {'lsp', 'ins-complete'}},
  {mode = '<c-p>'},
  {mode = '<c-n>'}
}

local saga = require('lspsaga')
saga.init_lsp_saga()

-------------------- GALAXYLINE ----------------------------

local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui','packer'}

local colors = {
  bg = '#282c34',
  yellow = '#deb974',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#a0c980',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#6cb6eb',
  red = '#ec5f67',
  pink = '#c981c5',
  violet=''
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {n = ' n ',i = ' i ',c= ' c ',v= ' v ',V= ' V ', [''] = ' - '}
      return alias[vim.fn.mode()]
    end,
    highlight = {colors.pink},
  },
}

gls.left[4] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color},
  },
}

gls.left[5] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.blue, nil}
  }
}

gls.left[6] = {
  GitIcon = {
    provider = function() return ' ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    highlight = {colors.violet},
  }
}

gls.left[7] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.yellow},
    separator = ' ',
  }
}

gls.left[8]= {
  DiagnosticError = {
    separator = ' ',
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red}
  }
}

gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow},
  }
}

gls.left[10] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan},
  }
}

gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
  }
}

gls.right[1] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green},
  }
}

gls.right[2] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange},
  }
}

gls.right[3] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red},
  }
}

gls.right[4] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = {colors.fg},
  },
}

gls.right[5] = {
  PerCent = {
    provider = 'LinePercent',
    highlight = {colors.fg},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    highlight = {colors.pink}
  }
}

gls.short_line_right[2] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.fg}
  }
}

gls.short_line_left[3] = {
  SFileName = {
    provider =  'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.blue}
  }
}

-------------------- NEOVIDE -------------------------------

g.neovide_remember_window_size = true
g.neovide_cursor_antialiasing = true

-------------------- COMMANDS ------------------------------

cmd "autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}"
cmd "autocmd BufEnter * lua require('completion').on_attach()"
cmd "autocmd FileType php setlocal shiftwidth=4 softtabstop=4"

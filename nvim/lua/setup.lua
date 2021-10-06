-------------------- HELPERS -------------------------------

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-------------------- COLORSCHEME ---------------------------

g.nord_italic = false
g.nord_italic_comments = false
g.nord_minimal_mode = false
g.colors_name = 'nordbuddy'

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

-------------------- AUTO-SAVE -----------------------------

local autosave = require('autosave')
autosave.setup({
  execution_message = ''
})

-------------------- SESSION -------------------------------

-- local session = require('auto-session')
-- session.setup {
--   auto_save_enabled = true,
--   auto_restore_enabled = true,
--   pre_save_cmds = {"NvimTreeClose"}
-- }

-------------------- GITSIGNS ------------------------------

local gitsigns = require('gitsigns')
gitsigns.setup()

-------------------- TELESCOPE -----------------------------

local telescope = require('telescope')
telescope.setup {
  pickers = {
    find_files = {
      hidden = true
    }
  },
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
autopairs.setup({
  ts
})

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
local nvimtree = require('nvim-tree')
nvimtree.setup {
  view = {
    mappings = {
      list = {
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
    }
  }
}

-------------------- LSP -----------------------------------

local lsp = require('lspconfig')
lsp.gopls.setup { on_attach = require('compe').on_attach }

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
  on_attach = require('compe').on_attach,
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

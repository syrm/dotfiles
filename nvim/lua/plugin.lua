-------------------- PLUGINS -------------------------------

local packer = require('packer')
packer.startup(function()
  use 'wbthomason/packer.nvim' -- package manager
  use 'hrsh7th/nvim-compe' -- autocompletion
  use {'nvim-treesitter/nvim-treesitter'} -- syntax
  use 'neovim/nvim-lspconfig' -- lsp to config server
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}} -- git
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}} -- finder
  use 'windwp/nvim-autopairs' -- autopair bracket
  use 'tpope/vim-surround' -- surround text
  use 'tpope/vim-commentary' -- add commentary
  use {'kyazdani42/nvim-tree.lua', requires = {'kyazdani42/nvim-web-devicons'}} -- file tree
  use {'glepnir/lspsaga.nvim', requires = {'nvim-lua/popup.nvim'}} -- lsp ui
  use {'akinsho/bufferline.nvim', requires = {'kyazdani42/nvim-web-devicons'}} -- buffer
  use {'glepnir/galaxyline.nvim', requires = {'kyazdani42/nvim-web-devicons'}} -- statusline
  use 'ggandor/lightspeed.nvim' -- fast jump
--  use 'rmagatti/auto-session' -- session
  use 'Pocco81/AutoSave.nvim' -- auto save

  -- Theme
  use 'sainnhe/edge'
  use 'codicocodes/tokyonight.nvim'
  use 'maaslalani/nordbuddy'
end)


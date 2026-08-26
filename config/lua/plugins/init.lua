return {
  "folke/lazy.nvim",

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  "navarasu/onedark.nvim",
  "EdenEast/nightfox.nvim",
  "rebelot/kanagawa.nvim",
  "Mofiqul/dracula.nvim",
  "sainnhe/everforest",

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      return require("config.snacks")
    end,
  },

  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  "lewis6991/gitsigns.nvim",

  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",

  {
    "numToStr/Comment.nvim",
    config = function()
      require("config.comment").setup()
    end,
  },

  "windwp/nvim-autopairs",

  "lukas-reineke/indent-blankline.nvim",

  "sindrets/winshift.nvim",

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
  },
}

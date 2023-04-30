 vim.opt.runtimepath:append("/home/ben/.config/nvim/parsers")

require'nvim-treesitter.configs'.setup {
  parser_install_dir = "/home/ben/.config/nvim/parsers",

  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "javascript", "nix", "haskell", "vim", "query"  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

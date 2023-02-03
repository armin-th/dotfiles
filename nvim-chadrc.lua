-- First read our docs (completely) then check the example_config repo

local M = {}

M.ui = {
  theme = "chocolate",
}

M.plugins = {
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities

      local lspconfig = require "lspconfig"

      local servers = {
        "rnix",
        "pylsp",
        "hls",
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end
  },
}

return M

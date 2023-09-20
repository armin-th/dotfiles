return {
  lsp = {
    servers = {
      "clangd",
      "hls",
      "pylsp",
      "rnix",
      "rust_analyzer",
      "tsserver",
    },
    config = {
      ["hls"] = {
        filetypes = { 'haskell', 'lhaskell' },
      },
    },
  },
}

return {
  lsp = {
    servers = {
      "clangd",
      "hls",
      "pylsp",
      "rnix",
      "rust_analyzer",
    },
    config = {
      ["hls"] = {
        filetypes = { 'haskell', 'lhaskell' },
      },
    },
  },
}

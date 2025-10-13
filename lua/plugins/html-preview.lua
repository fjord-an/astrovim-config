-- HTML and Live Preview Configuration
-- Provides both in-editor HTML viewing with w3m and live development server
return {
  -- W3m in-editor HTML viewer
  {
    "yuratomo/w3m.vim",
    lazy = true,
    cmd = { "W3m", "W3mTab", "W3mSplit", "W3mVSplit" },
    ft = { "html" },
    keys = {
      { "<leader>mw", "<cmd>W3mSplit<cr>", desc = "W3m Split Preview", ft = "html" },
      { "<leader>mh", "<cmd>W3m<cr>", desc = "W3m Preview", ft = "html" },
    },
  },

}

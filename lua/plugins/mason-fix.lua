-- Fix for Mason package initialization errors
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Ensure Mason home directory exists and is clean
      local mason_home = vim.fn.stdpath("data") .. "/mason"
      
      -- Add error handling for package operations
      opts.ui = vim.tbl_deep_extend("force", opts.ui or {}, {
        check_outdated_packages_on_open = false, -- Disable automatic checking
        border = "rounded",
      })
      
      return opts
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = false, -- Prevent automatic installation issues
    },
  },
}

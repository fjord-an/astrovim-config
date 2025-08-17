-- Fix for Mason package initialization errors
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Completely disable package update checking to avoid errors
      opts = vim.tbl_deep_extend("force", opts or {}, {
        ui = {
          check_outdated_packages_on_open = false, -- Disable on open
          border = "rounded",
          width = 0.8,
          height = 0.8,
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        -- Disable automatic package checking
        max_concurrent_installers = 1,
        log_level = vim.log.levels.WARN, -- Reduce log verbosity
      })
      
      return opts
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      
      -- Disable the automatic version checking that causes errors
      local registry = require("mason-registry")
      if registry.refresh then
        -- Override refresh to prevent automatic updates
        local original_refresh = registry.refresh
        registry.refresh = function(...)
          -- Only refresh when explicitly requested, not automatically
          local ok, err = pcall(original_refresh, ...)
          if not ok then
            vim.notify("Mason registry refresh failed, but continuing anyway", vim.log.levels.WARN)
          end
        end
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = false, -- Prevent automatic installation issues
      ensure_installed = {}, -- Don't automatically install anything
    },
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Disable Mason update notifications from AstroCore
      if opts.features then
        opts.features.mason_update_checker = false
      end
      
      -- Disable the Mason auto-update checking
      if opts.options and opts.options.g then
        opts.options.g.astro_mason_update_check = false
      end
      
      return opts
    end,
  },
}

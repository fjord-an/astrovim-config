-- Fixed Mason configuration with proper error handling
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- Update Mason registry on install/update
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
        ui = {
          check_outdated_packages_on_open = true, -- Re-enable checking but with error handling
          border = "rounded",
          width = 0.8,
          height = 0.8,
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        max_concurrent_installers = 4,
        log_level = vim.log.levels.INFO,
        -- Add PATH prepend to ensure Mason binaries are found
        PATH = "prepend",
      })
      
      return opts
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      
      -- Add error handling for registry operations
      local registry = require("mason-registry")
      
      -- Wrap the update handler to catch errors
      local handle_package_updates = function()
        local ok, err = pcall(function()
          registry.refresh(function()
            for _, pkg in ipairs(registry.get_installed_packages()) do
              -- Safely check for updates
              local success, update_err = pcall(function()
                if pkg.check_new_version then
                  pkg:check_new_version(function(success, result_or_err)
                    if not success then
                      -- Silently ignore individual package errors
                      vim.schedule(function()
                        vim.notify(
                          string.format("Failed to check updates for %s: %s", pkg.name, tostring(result_or_err)),
                          vim.log.levels.DEBUG
                        )
                      end)
                    end
                  end)
                end
              end)
              if not success then
                -- Log but don't crash on individual package errors
                vim.schedule(function()
                  vim.notify(
                    string.format("Error checking package %s: %s", pkg.name or "unknown", tostring(update_err)),
                    vim.log.levels.DEBUG
                  )
                end)
              end
            end
          end)
        end)
        
        if not ok then
          vim.schedule(function()
            vim.notify("Mason registry update check failed: " .. tostring(err), vim.log.levels.WARN)
          end)
        end
      end
      
      -- Set up a safer auto-update check
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(handle_package_updates, 3000) -- Delay 3 seconds after startup
        end,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true, -- Re-enable but with specific list
      ensure_installed = {
        "lua_ls",        -- Lua
        "bashls",        -- Bash
        "jsonls",        -- JSON
        "yamlls",        -- YAML
        "marksman",      -- Markdown
        "html",          -- HTML
        "cssls",         -- CSS
        "tsserver",      -- TypeScript/JavaScript
        "pyright",       -- Python
      },
    },
  },
}

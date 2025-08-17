-- Helper script to reinstall Mason packages after cleanup
-- Run this with :lua require("user.mason-reinstall").reinstall()

local M = {}

M.packages_to_install = {
  -- LSP Servers
  "bash-language-server",
  "lua-language-server",
  "jedi-language-server",
  "docker-compose-language-service",
  "marksman",
  "markdown-oxide",
  "harper-ls",
  
  -- Formatters
  "stylua",
  "prettierd",
  "prettier",
  "beautysh",
  "yamlfmt",
  "yamlfix",
  "sql-formatter",
  "nginx-config-formatter",
  "mdformat",
  
  -- Linters
  "markdownlint",
  "markdownlint-cli2",
  "yamllint",
  "gitlint",
  "gitleaks",
  "commitlint",
  "pylama",
  "selene",
  "curlylint",
  
  -- Debug Adapters
  "chrome-debug-adapter",
  "netcoredbg",
  
  -- Other tools
  "markdown-toc",
  "csharpier",
  "terraform",
}

M.reinstall = function()
  local registry = require("mason-registry")
  local mason_install = require("mason.api.command")
  
  vim.notify("Starting Mason package reinstallation...", vim.log.levels.INFO)
  
  -- First, refresh the registry
  registry.refresh(function()
    vim.notify("Mason registry refreshed", vim.log.levels.INFO)
    
    -- Install each package
    for _, package_name in ipairs(M.packages_to_install) do
      local ok, pkg = pcall(registry.get_package, package_name)
      if ok and pkg then
        if not pkg:is_installed() then
          vim.notify("Installing " .. package_name, vim.log.levels.INFO)
          pkg:install()
        else
          vim.notify(package_name .. " is already installed", vim.log.levels.DEBUG)
        end
      else
        vim.notify("Package not found in registry: " .. package_name, vim.log.levels.WARN)
      end
    end
  end)
end

M.check_installed = function()
  local registry = require("mason-registry")
  local installed = {}
  local missing = {}
  
  for _, package_name in ipairs(M.packages_to_install) do
    local ok, pkg = pcall(registry.get_package, package_name)
    if ok and pkg and pkg:is_installed() then
      table.insert(installed, package_name)
    else
      table.insert(missing, package_name)
    end
  end
  
  vim.notify("Installed packages: " .. table.concat(installed, ", "), vim.log.levels.INFO)
  if #missing > 0 then
    vim.notify("Missing packages: " .. table.concat(missing, ", "), vim.log.levels.WARN)
  end
end

return M

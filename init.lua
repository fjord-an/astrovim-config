-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

-- augment_workspace_folders for context
vim.g.augment_workspace_folders =
  { "~/Projects/", "~/Documents/augment-projects/", "~/Documents/Notes/Obsidian/Brain/Brain/Brain/" }

-- Neovide configuration
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h18"
  -- Enable use of the logo (cmd/super) key for better macOS integration
  vim.g.neovide_input_use_logo = 1
  -- Enable Cmd+V paste in command mode
  vim.keymap.set('c', '<D-v>', '<C-R>+')
  -- Enable Cmd+V paste in insert mode
  vim.keymap.set('i', '<D-v>', '<C-R>+')
  -- Enable Cmd+C copy in visual mode
  vim.keymap.set('v', '<D-c>', '"+y')
  -- Enable Cmd+V paste in normal and visual modes
  vim.keymap.set({'n', 'v'}, '<D-v>', '"+P')
end

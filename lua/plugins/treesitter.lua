-- Treesitter configuration - REQUIRED for render-markdown.nvim and codecompanion.nvim
-- NOTE: Explicitly using the stable `master` branch. The `main` branch is a rewrite
--       that downloads precompiled tarballs and often fails on macOS with BSD tar.
--       The `master` branch compiles from source using the tree-sitter CLI.
--
-- IMPORTANT: You need the tree-sitter CLI installed:
--   brew install tree-sitter
--   OR: mise use -g tree-sitter
--
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    auto_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      -- Disable for large files and special buffers to avoid lag/errors
      disable = function(lang, buf)
        local max_filesize = 1000 * 1024 -- 1 MB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end

        local ft = vim.bo[buf].filetype
        local bt = vim.bo[buf].buftype
        -- Disable for UI/file-manager buffers that trigger treesitter errors
        if vim.tbl_contains({ "neo-tree", "neo-tree-popup", "netrw", "help", "nofile", "prompt", "TelescopePrompt" }, ft) then
          return true
        end
        if vim.tbl_contains({ "nofile", "prompt", "quickfix" }, bt) then
          return true
        end

        return false
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Fix: nvim-treesitter query_predicates.lua assumes match[id] is a single TSNode,
    -- but Neovim 0.10+ changed TSQueryMatch:captures() to return TSNode[] (arrays).
    -- This causes "attempt to call method 'range' (a nil value)" in markdown injections.
    -- Re-register the affected handlers with array-unwrapping versions.
    -- See: https://github.com/nvim-treesitter/nvim-treesitter/issues (unfixed on master)
    local query = require("vim.treesitter.query")
    local register_opts = { force = true, all = false }

    local html_script_type_languages = {
      ["importmap"] = "json",
      ["module"] = "javascript",
      ["application/ecmascript"] = "javascript",
      ["text/ecmascript"] = "javascript",
    }

    local non_filetype_match_injection_language_aliases = {
      ex = "elixir",
      pl = "perl",
      sh = "bash",
      uxn = "uxntal",
      ts = "typescript",
    }

    local function get_parser_from_markdown_info_string(injection_alias)
      local m = vim.filetype.match({ filename = "a." .. injection_alias })
      return m or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
    end

    -- Helper: unwrap first node from captures array (Neovim 0.10+ format)
    local function first_node(match, id)
      local nodes = match[id]
      if not nodes or #nodes == 0 then
        return nil
      end
      return nodes[1]
    end

    -- Predicates

    query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
      local node = first_node(match, pred[2])
      local n = tonumber(pred[3])
      if node and node:parent() and node:parent():named_child_count() > n then
        return node:parent():named_child(n) == node
      end
      return false
    end, register_opts)

    query.add_predicate("is?", function(match, _pattern, bufnr, pred)
      local node = first_node(match, pred[2])
      if not node then
        return true
      end
      local locals = require("nvim-treesitter.locals")
      local _, _, kind = locals.find_definition(node, bufnr)
      return vim.tbl_contains({ unpack(pred, 3) }, kind)
    end, register_opts)

    query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
      local node = first_node(match, pred[2])
      if not node then
        return true
      end
      return vim.tbl_contains({ unpack(pred, 3) }, node:type())
    end, register_opts)

    -- Directives

    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
        return
      end
      local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
      local configured = html_script_type_languages[type_attr_value]
      if configured then
        metadata["injection.language"] = configured
      else
        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
      end
    end, register_opts)

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = first_node(match, pred[2])
      if not node then
        return
      end
      local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
    end, register_opts)

    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = first_node(match, id)
      if not node then
        return
      end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
      if not metadata[id] then
        metadata[id] = {}
      end
      metadata[id].text = string.lower(text)
    end, register_opts)
  end,
}

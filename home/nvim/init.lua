--[[**************************************@******************************************
*                                  BASIC SETTINGS                                   *
*********************************************************************************--]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.cursorlineopt = "number"
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shell = "zsh"
-- Override tab settings for all file current types
vim.cmd([[
  autocmd FileType * setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
]])

-- KEYMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })                -- Save
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })                -- Quit
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { noremap = true, silent = true })               -- Quit force!
vim.keymap.set("n", "<leader>R", ":luafile $MYVIMRC<CR>", { noremap = true, silent = true }) -- Reload config
vim.keymap.set("n", "<leader>W", "<C-w>w", { noremap = true, silent = true })                -- Change window
vim.keymap.set("n", "zx", "1z=", { noremap = true, silent = true })
vim.g.lexima_enable_basic_rules = 1

function _G.smart_bdelete_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local listed = vim.fn.getbufinfo({ buflisted = 1 })
  local is_alpha = vim.bo[bufnr].filetype == "alpha"

  if #listed <= 1 and not is_alpha then
    require("alpha").start(false)
    vim.cmd("bp")
    vim.api.nvim_buf_delete(bufnr, { force = true })
  else
    vim.cmd("bp")
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

vim.keymap.set("n", "<leader>bd", smart_bdelete_buffer, { desc = "Smart buffer delete (force)" })

vim.keymap.set("n", "<leader>bp", ":bp<CR>", { noremap = true }) -- Previous Buffer
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { noremap = true }) -- Next Buffer
vim.keymap.set("n", "<ESC>", function()
  vim.cmd("nohlsearch")
  return "<ESC>"
end, { expr = true, noremap = true })

require("hex").setup()

-- Configure clipboard
vim.opt.clipboard:append("unnamedplus")
--[[**************************************@******************************************
*                                      THEME                                        *
*********************************************************************************--]]
local kanagawa_config = {
  transparent = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
}
require("kanagawa").setup(kanagawa_config)
vim.cmd("colorscheme kanagawa")
vim.cmd("highlight CursorLineNr guifg=#957fb8")

local function toggle_transparency()
  kanagawa_config.transparent = not kanagawa_config.transparent
  require("kanagawa").setup(kanagawa_config)
  vim.cmd("colorscheme kanagawa")
  vim.cmd("highlight CursorLineNr guifg=#957fb8")
end

vim.keymap.set("n", "<leader>T", toggle_transparency, { noremap = true, silent = true })

--[[**************************************@******************************************
*                                        Oil                                        *
*********************************************************************************--]]
local oil = require("oil")
oil.setup({
  float = {
    win_options = {
      winblend = 0,
    },
  },
})
vim.keymap.set("n", "-", function()
  vim.cmd("Oil")
end, { desc = "Open parent directory and show CWD" })

function _G.oil_or_buff_wd()
  local oil_dir = oil.get_current_dir()
  local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  return oil_dir or buf_dir
end

--[[**************************************@******************************************
*                                      LUALINE                                      *
*********************************************************************************--]]
require("lualine").setup({
  sections = {
    lualine_c = {
      function()
        if vim.bo.filetype == "oil" then
          return oil.get_current_dir():gsub(vim.env.HOME, "~")
        else
          return vim.fn.expand("%:t")
        end
      end,
    },
  },
})

--[[**************************************@******************************************
*                                     TELESCOPE                                     *
*********************************************************************************--]]
require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",
    },
  },
  pickers = {
    colorscheme = { enable_preview = true, theme = "ivy" },
    live_grep = {
      theme = "ivy",
      file_ignore_patterns = { ".git" },
    },
    find_files = {
      theme = "ivy",
      hidden = true,
      find_command = {
        "rg",
        "--files",
        "--glob",
        "!{.git/*,target/*}",
      },
    },
    lsp_type_definitions = { theme = "ivy" },
    lsp_references = { theme = "ivy" },
    lsp_document_symbols = { theme = "ivy" },
    current_buffer_fuzzy_find = { theme = "ivy" },
    treesitter = { theme = "ivy" },
    oldfiles = { theme = "ivy" },
    help_tags = { theme = "ivy" },
    grep_string = { theme = "ivy" },
    buffers = { theme = "ivy" },
  },
})
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>lt", telescope_builtin.lsp_type_definitions, {})
vim.keymap.set("n", "<leader>lr", telescope_builtin.lsp_references, {})
vim.keymap.set("n", "<leader>ls", telescope_builtin.lsp_document_symbols, {})

vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fm", telescope_builtin.marks, {})
vim.keymap.set("n", "<leader>fr", telescope_builtin.oldfiles, {})

vim.keymap.set("n", "<leader>ss", telescope_builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>st", telescope_builtin.treesitter, {})
vim.keymap.set("n", "<leader>sw", function()
  telescope_builtin.grep_string({ cwd = oil_or_buff_wd() })
end, {})
vim.keymap.set("n", "<leader>sp", function()
  telescope_builtin.live_grep({ cwd = oil_or_buff_wd() })
end, {})

vim.keymap.set("n", "<leader>fw", function()
  telescope_builtin.grep_string({ cwd = vim.fn.getcwd() })
end, {})
vim.keymap.set("n", "<leader>cp", function()
  telescope_builtin.live_grep({ cwd = vim.fn.getcwd() })
end, {})

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

_G.buffer_searcher = function()
  telescope_builtin.buffers({
    sort_mru = true,
    ignore_current_buffer = true,
    show_all_buffers = false,
    attach_mappings = function(prompt_bufnr, map)
      local refresh_buffer_searcher = function()
        actions.close(prompt_bufnr)
        vim.schedule(buffer_searcher)
      end

      local delete_buf = function()
        local selection = action_state.get_selected_entry()
        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        refresh_buffer_searcher()
      end

      local delete_multiple_buf = function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local selection = picker:get_multi_selection()
        for _, entry in ipairs(selection) do
          vim.api.nvim_buf_delete(entry.bufnr, { force = true })
        end
        refresh_buffer_searcher()
      end

      map("n", "dd", delete_buf)
      map("n", "<C-d>", delete_multiple_buf)
      map("i", "<C-d>", delete_multiple_buf)

      return true
    end,
  })
end

vim.keymap.set("n", "<leader>fb", buffer_searcher, {})

--[[**************************************@******************************************
*                                        CMP                                        *
*********************************************************************************--]]
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }, {
    { name = "buffer" },
  }),
})

--[[**************************************@******************************************
*                                        UFO (folding)                              *
*********************************************************************************--]]
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local ufo = require("ufo")
vim.keymap.set("n", "zR", ufo.openAllFolds)
vim.keymap.set("n", "zM", ufo.closeAllFolds)
vim.keymap.set("n", "zK", function()
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end)

ufo.setup({
  provider_selector = function(bufnr, filetype, buftype)
    return { "treesitter", "indent" }
  end,
})

-- Safe previous paragraph
vim.keymap.set("n", "{", function()
  local prev = vim.fn.line(".")
  repeat
    vim.cmd("normal! {")
    local curr = vim.fn.line(".")
    if curr == prev then
      break
    end -- stop if stuck
    prev = curr
  until vim.fn.foldclosed(curr) == -1
end, { noremap = true })

-- Safe next paragraph
vim.keymap.set("n", "}", function()
  local prev = vim.fn.line(".")
  repeat
    vim.cmd("normal! }")
    local curr = vim.fn.line(".")
    if curr == prev then
      break
    end -- stop if stuck
    prev = curr
  until vim.fn.foldclosed(curr) == -1
end, { noremap = true })

--[[**************************************@******************************************
*                                        LSP                                        *
*********************************************************************************--]]
vim.diagnostic.config({
  virtual_text = true,      --  Show diagnostics as virtual text (inline)
  signs = true,             --	 Show signs in the gutter
  underline = true,         --  Underline problematic code
  update_in_insert = false, -- Don't show diagnostics while typing
  severity_sort = true,     --  Sort diagnostics by severity
})
vim.o.signcolumn = "yes"

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.b[bufnr].autoformat = false;
  -- Define key mappings for LSP functions
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)             -- Go to definition
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)         -- Go to implementation
  -- vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)    -- Done by telescope
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.hover, opts)          -- Hover documentation
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, opts) -- Signature hint
  vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)         -- Rename variable
  vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)    -- Code actions

  local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end
  vim.keymap.set("n", "<leader>lH", toggle_inlay_hints, opts) -- Signature hint

  local function goto_diagnositc(next)
    return function()
      local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf())
      if #diags == 0 then return end
      local max_severity = tonumber(vim.diagnostic.severity.HINT)
      for _, d in pairs(diags) do
        if max_severity > d.severity then
          max_severity = tonumber(d.severity)
        end
      end

      local count = next and 1 or -1
      vim.diagnostic.jump({ count = count, severity = max_severity, float = true, wrap = true })
      vim.cmd("normal! zz")
    end
  end
  vim.keymap.set("n", "<leader>ej", goto_diagnositc(true), opts)  -- Jump to diagnostic
  vim.keymap.set("n", "<leader>ek", goto_diagnositc(false), opts) -- Jump to diagnostic

  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      if vim.b[bufnr].autoformat then
        vim.lsp.buf.format({ async = false })
      end
    end,
  })

  local function toggle_autoformat()
    vim.b[bufnr].autoformat = not vim.b[bufnr].autoformat
    if vim.b[bufnr].autoformat then
      vim.notify("Autoformat: ON", vim.log.levels.INFO)
    else
      vim.notify("Autoformat: OFF", vim.log.levels.INFO)
    end
  end

  vim.keymap.set("n", "<leader>lf", toggle_autoformat, opts)
end

local lspconfig = require("lspconfig")
--[[**************************************@******************************************
*                                      NULL-LS (LSP)                                *
*********************************************************************************--]]

--[[**************************************@******************************************
*                                       C/C++                                       *
*********************************************************************************--]]
lspconfig.clangd.setup({
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
  single_file_support = true,
  on_attach = on_attach,
})

--[[**************************************@******************************************
*                                      PYTHON                                       *
*********************************************************************************--]]
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

--[[**************************************@******************************************
*                                        LUA                                        *
*********************************************************************************--]]
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- Recognize `vim` as a global
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
      telemetry = { -- Disable spies
        enable = false,
      },
    },
  },
  on_attach = on_attach
})

--[[**************************************@******************************************
*                                        NIX                                        *
*********************************************************************************--]]
lspconfig.nil_ls.setup({
  on_attach = on_attach,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
    end
  end,
})

--[[**************************************@******************************************
*                                       OCaml                                       *
*********************************************************************************--]]
if vim.fn.executable('ocamllsp') == 1 then
  vim.lsp.enable('ocamllsp')
  vim.lsp.config('ocamllsp', {
    on_attach = on_attach,
    settings = {
      inlayHints = {
        hintPatternVariables = true,
        hintLetBindings = true,
        hintFunctionParams = true
      },
    }
  })
end

--[[**************************************@******************************************
*                                       JULIA                                       *
*********************************************************************************--]]
vim.g.latex_to_unicode_tab = 1
vim.g.latex_to_unicode_suggestions = 1

--[[**************************************@******************************************
*                                        RUST                                       *
*********************************************************************************--]]
vim.g.rustaceanvim = {
  tools = {},
  server = {
    on_attach = on_attach,
    default_settings = {
      ["rust-analyzer"] = {
        procMacro = {
          enable = false,
          ignored = {
            ["miette"] = { "Diagnostic" },
            ["thiserror"] = { "Error" },
          },
        }
      },
    },
  },
}

vim.keymap.set("n", "<leader>cdb", ":AsyncRun cargo r<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cdr", ":AsyncRun cargo b<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cb", ":AsyncRun cargo b -r<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cr", ":AsyncRun cargo r -r<CR>", { noremap = true, silent = true })

--[[**************************************@******************************************
*                                      TERMINAL                                     *
*********************************************************************************--]]
-- Only apply the terminal <Esc> mapping when the buffer isn't lazygit
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("lazygit") then
      return
    end
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = true, silent = true })
  end,
})

-- Terminal mode cursor
vim.cmd([[
  augroup TerminalCursorColor
    autocmd!
    autocmd TermEnter * highlight TermCursor guifg=#7e9cd8
  augroup END
]])

--[[**************************************@******************************************
*                                       TYPST                                       *
*********************************************************************************--]]
lspconfig.tinymist.setup({
  settings = {
    formmaterMode = "typstyle",
  },
  single_file_support = true,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>tP", function()
      client:exec_cmd({
        title = "pin",
        command = "tinymist.pinMain",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [P]in", noremap = true })
    vim.keymap.set("n", "<leader>tU", function()
      client:exec_cmd({
        title = "unpin",
        command = "tinymist.pinMain",
        arguments = { vim.v.null },
      }, { bufnr = bufnr })
    end, { desc = "[T]inymist [U]npin", noremap = true })
    vim.keymap.set("n", "<leader>tp", ":TypstPreviewToggle<CR>", { noremap = true, silent = true })
  end,
})
-- vim.g.typst_conceal = 1 -- Currently broken with TreeSitter =(, Kinda usless anyway since i always run the preview
-- vim.g.typst_conceal_emoji = 1
-- vim.g.typst_conceal_math = 1

require("typst-preview").setup({
  --  invert_colors = "always",
  open_cmd = "google-chrome-stable --app=%s --hide-scrollbars 2>/dev/null",
})

--[[**************************************@******************************************
*                                       LATEX                                       *
*********************************************************************************--]]
-- vim.g.vimtex_view_method = "general"
-- vim.g.vimtex_general_viewer = "sioyek"
-- vim.g.vimtex_general_options =
-- '--shell-escape --forward-search-file @tex --forward-search-line @line --inverse-search "nvim --headless -c \\"VimtexInverseSearch %2 \'%1\'\\""'
-- vim.g.vimtex_compiler_method = "latexmk"
--
-- -- Autocommand to set Vimtex options when opening LaTeX files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "tex",
--   callback = function()
--     vim.g.vimtex_view_method = "general"
--     vim.g.vimtex_view_general_viewer = "sioyek"
--     vim.g.vimtex_view_general_options =
--     '--forward-search-file @tex --forward-search-line @line --inverse-search "nvim --headless -c \\"VimtexInverseSearch %2 \'%1\'\\""'
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "tex",
--   callback = function()
--     -- Keymap for VimtexCompile
--     vim.api.nvim_buf_set_keymap(0, "n", "<leader>c", ":VimtexCompile<CR>", { noremap = true, silent = true })
--     -- Keymap for VimtexView
--     vim.api.nvim_buf_set_keymap(0, "n", "<leader>v", ":VimtexView<CR>", { noremap = true, silent = true })
--   end,
-- })
--
-- -- Configure Texlab
-- lspconfig.texlab.setup({
--   filetypes = { "tex" },
--   settings = {
--     texlab = {
--       build = {
--         executable = "latexmk",
--         args = { "-pdf", "--shell-escape", "-interaction=nonstopmode", "-synctex=1", "%f" },
--         onSave = true, -- Automatically build on save
--       },
--       auxDirectory = ".", -- I should tinker with this
--       diagnostics = {
--         enabled = true,
--         delay = 300,
--       },
--     },
--   },
--   on_attach = on_attach,
-- })

--[[**************************************@******************************************
*                              ALPHA DASHBOARD SETTINGS                             *
*********************************************************************************--]]
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

vim.api.nvim_set_keymap("n", "<leader>h", ":Alpha<CR>", { noremap = true, silent = true })

dashboard.section.header.val = {
  [[                                                                       ]],
  [[ ╔██████  ╔█████                  ╔█████  ╔█████ ╔███                  ]],
  [[ ╚╗██████ ╚╗███                   ╚╗███   ╚╗███╝ ╚══╝                  ]],
  [[  ║███║███ ║███  ╔██████  ╔██████  ║███    ║███ ╔████ ╔█████████████   ]],
  [[  ║███╚╗███║███ ╔███═╗███╔███═╗███ ║███    ║███ ╚╗███ ╚╗███═╗███═╗███  ]],
  [[  ║███ ╚╗██████ ║███████╝║███ ║███ ╚╗███   ███╝  ║███  ║███ ║███ ║███  ]],
  [[  ║███  ╚╗█████ ║███═══╝ ║███ ║███  ╚═╗█████═╝   ║███  ║███ ║███ ║███  ]],
  [[ ╔█████  ╚╗█████╚╗██████ ╚╗██████     ╚╗███╝    ╔█████╔█████║███╔█████ ]],
  [[ ╚════╝   ╚════╝ ╚═════╝  ╚═════╝      ╚══╝     ╚════╝╚════╝╚══╝╚════╝ ]],
  [[                                                                       ]],
}

dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"), -- New file
  dashboard.button("SPC f f", "󰍉  Find file"), -- Find file
  dashboard.button("SPC f r", "  Recent"), -- Recent files
  dashboard.button("SPC s p", "  Grep"), -- Grep
  dashboard.button("c", "  Configuration", ":e ~/aaros/home/nvim/init.lua<CR>"), -- Open neovim config
  dashboard.button("h", "  Home manager", ":e ~/aaros/home/default.nix<CR>"), -- Open home manager
  dashboard.button("t", "󰆍  Terminal", ":terminal<CR>i"), -- Open home manager
  dashboard.button("q", "󰈆  Quit NVIM", ":qa<CR>"), -- Quit Neovim
}

local function footer_padding()
  local total_height = #dashboard.section.header.val + #dashboard.section.buttons.val + #dashboard.section.footer.val
  local screen_height = vim.fn.winheight(0)
  local padding = math.floor((screen_height - total_height) / 2)
  return padding > 0 and padding or 0
end

dashboard.config.layout = {
  { type = "padding", val = footer_padding() },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

--[[**************************************@******************************************
*                                        GIT                                        *
********************************************************************************--]]
local function _lazygit_open()
  local cwd = vim.fn.getcwd()
  if vim.bo.filetype == "oil" then
    vim.cmd("lcd" .. oil.get_current_dir())
    vim.cmd("LazyGit")
    vim.cmd("lcd" .. cwd)
  else
    vim.cmd("LazyGitCurrentFile")
  end
end

vim.keymap.set("n", "<leader>g", _lazygit_open, { noremap = true, silent = true })

--[[**************************************@*****************************************
*                                    TREESITER                                     *
********************************************************************************--]]
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
  textsubjects = {
    enable = true,
    prev_selection = ",",
    keymaps = {
      ["."] = "textsubjects-smart",
      ["a;"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
})

--[[**************************************@*****************************************
*                                ASYNCRUN & FLOATERM                               *
********************************************************************************--]]
vim.g.floaterm_autoinsert = true
vim.g.asyncrun_open = 0
vim.keymap.set("n", "<A-s>", ":FloatermToggle<CR>", { noremap = true })
vim.keymap.set("t", "<A-s>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true })
vim.api.nvim_create_user_command("AsyncRunTerm", function(opts)
  local cmd = table.concat(opts.fargs, " ")
  vim.cmd("AsyncRun -mode=term -pos=floaterm_reuse " .. cmd)
end, { nargs = "+", complete = "shellcmd" })

vim.keymap.set("n", "gf", function()
  if vim.bo.buftype == "terminal" then
    local path = vim.fn.expand("<cfile>")
    local word = vim.fn.expand("<cWORD>")
    local line = nil
    local col = nil

    local colon_pos = word:find(":")
    if colon_pos then
      line = word:sub(colon_pos + 1)
      line, col = line:match("^(%d+):(%d+)")
      if line then
        line = tonumber(line)
      end
      if col then
        col = tonumber(col)
      end
    end

    vim.cmd("FloatermHide")
    local buf = vim.fn.bufnr(path)
    if buf ~= -1 then
      vim.cmd("buffer " .. buf)
    else
      vim.cmd("edit " .. path)
    end
    if line ~= nil then
      vim.api.nvim_win_set_cursor(0, { line, col - 1 })
    end
  else
    vim.cmd("normal! gf")
  end
end, { noremap = true, silent = true })


require("nvim-surround").setup()
require("leap").setup({})
vim.keymap.set("n", "L", "<Plug>(leap-anywhere)")


-- EASY ALIGN
-- Start interactive EasyAlign in visual mode (e.g. vipga)
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { silent = true })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { silent = true })


local dap = require("dap")
local dapui = require("dapui")

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
require("nvim-dap-virtual-text").setup {
  -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
  display_callback = function(variable)
    local name = string.lower(variable.name)
    local value = string.lower(variable.value)
    if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
      return "*****"
    end

    if #variable.value > 15 then
      return " " .. string.sub(variable.value, 1, 15) .. "... "
    end

    return " " .. variable.value
  end,
}
dapui.setup()


vim.keymap.set("n", "<A-b>", dap.toggle_breakpoint)
vim.keymap.set("n", "<A-g>", dap.run_to_cursor)
vim.keymap.set("n", "<A-?>", function()
  require("dapui").eval(nil, { enter = true })
end)
vim.keymap.set("n", "<A-c>", dap.continue)
vim.keymap.set("n", "<A-i>", dap.step_into)
vim.keymap.set("n", "<A-o>", dap.step_over)
vim.keymap.set("n", "<A-u>", dap.step_out)
vim.keymap.set("n", "<A-k>", dap.step_back)
vim.keymap.set("n", "<A-r>", dap.restart)
vim.keymap.set("n", "<A-l>", dap.run_last)

vim.keymap.set("n", "<A-u>o", dapui.open)
vim.keymap.set("n", "<A-u>c", dapui.close)

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

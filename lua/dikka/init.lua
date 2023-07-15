require('dikka.scrolloff')
-- REMAPS
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set({ 'n', 'v' }, '<C-s>', vim.cmd.w)

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv")

vim.keymap.set('n', '<C-e>', '5<C-e>')
vim.keymap.set('n', '<C-y>', '5<C-y>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', 'zx', 'zz')

vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set({ 'n', 'v' }, 'Q', '<nop>')

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

vim.keymap.set('x', '<leader>p', '|_dP')

vim.keymap.set('n', '<leader>q', ':set wrap!<CR>')
vim.keymap.set('n', '<leader>w', '<C-w>')
vim.keymap.set('n', '<C-Q>', ':xa<CR>')

vim.keymap.set('v', '<leader>s', function()
    -- Start undo block
    vim.cmd('normal! u')

    -- Save the current register and clipboard settings
    local old_reg = vim.fn.getreg('"')
    local old_clipboard = vim.o.clipboard

    -- Don't allow system clipboard to be affected
    vim.o.clipboard = ''

    -- Visually select the previously visually-selected text and yank it
    vim.cmd('normal! gv"xy')

    -- Get the yanked text from the unnamed register
    local selected_text = vim.fn.getreg('"')

    -- Restore the old register and clipboard settings
    vim.fn.setreg('"', old_reg)
    vim.o.clipboard = old_clipboard

    -- End undo block
    vim.cmd('normal! u')

    vim.cmd('normal! <C-c>') -- Go back to normal mode

    selected_text = selected_text:gsub("/", "\\/")

    local range = vim.fn.input("Enter the range offset: ")
    local command_start = ':'

    if range == '%' then
        command_start = command_start .. '%'
    else
        if type(range) == 'number' then
            command_start = command_start .. ',+' .. range
        else
            command_start = command_start .. ',' .. range
        end
    end

    local command = command_start .. "s/\\(" .. selected_text .. "\\)//gi"
    print(command)

    -- Simulate typing the command into the command-line, but don't execute it
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command .. "<Left><Left><Left>", true, true, true), 'n',
        false)
end, { noremap = true })

-- CONFIGS
vim.opt.clipboard = 'unnamedplus'
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.inccommand = "nosplit"

vim.opt.termguicolors = true

-- vim.opt.scrolloff = 16
vim.opt.signcolumn = "yes:1"

vim.opt.updatetime = 500

vim.opt.splitright = true
-- vim.opt.colorcolumn = "80"

-- LAZY
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
    print('Installing lazy.nvim....')
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Utility
    {
        'nvim-lua/plenary.nvim',
    },

    -- Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- LSP & Autocompletion
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },

    -- File Explorer & Searching
    {
        'nvim-telescope/telescope.nvim',
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
    },
    {
        'ThePrimeagen/harpoon',
    },

    -- Syntax Highlighting & Code Understanding
    {
        'nvim-treesitter/nvim-treesitter',
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
    },

    -- Key Mapping Help
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    -- Git Tools
    {
        "kdheepak/lazygit.nvim",
    },
    {
        'lewis6991/gitsigns.nvim',
        as = 'gitsigns',
    },

    -- Editing Tools
    {
        'mbbill/undotree',
    },
    {
        'cohama/lexima.vim',
    },
    {
        'echasnovski/mini.surround',
        version = '*'
    },
    {
        'echasnovski/mini.ai',
        version = '*'
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'aznhe21/actions-preview.nvim',
        config = function()
            vim.keymap.set({ 'v', 'n' }, '<leader>vc', require('actions-preview').code_actions)
        end,
    },

    -- AI Tools
    {
        'github/copilot.vim',
    },

    -- Clipboard Manager
    {
        'AckslD/nvim-neoclip.lua',
    },

    -- Miscellaneous
    {
        'echasnovski/mini.comment',
        version = '*'
    },
    {
        'eandrju/cellular-automaton.nvim',
    },
    {
        'rmagatti/auto-session',
    },
    {
        'm-demare/attempt.nvim',
    },
    {
        'numToStr/FTerm.nvim',
    },
})
--PLUGINSEND

-- PLUGINS CONFIGS
require("tokyonight").setup({
    style = 'night',
})
vim.cmd [[colorscheme tokyonight]]

-- telescope
require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ['<C-x>'] = 'select_vertical'
            }
        }
    },
}

local tele = require('telescope.builtin')
local tele_actions = require('telescope.actions')
vim.keymap.set('n', '<leader>pf', tele.find_files, {})
vim.keymap.set('n', '<C-p>', tele.git_files, {})
vim.keymap.set('n', '<leader>ps', tele.live_grep, {})

-- treesitter
require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "markdown", "javascript", "go", "rust", "typescript", "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- lsp-zero
local lsp = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_sources = 'recommended',
        set_extra_mappings = false,
    }
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr }

    vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
    vim.keymap.set('n', '<leader>vd', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>vr', '<cmd>TroubleToggle lsp_references<cr>', opts)
    vim.keymap.set('n', '<leader>vn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }
})

require('lspconfig').rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all"
            },
        }
    }
})

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- lazygit
vim.keymap.set("n", "<leader>lg", vim.cmd.LazyGit)

-- cellular automaton
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- harpoon

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

-- mini.ai
require('mini.ai').setup()

-- mini.comment
require('mini.comment').setup()

-- gitsigns
require('gitsigns').setup()

-- neoclip
require('neoclip').setup()
require('telescope').load_extension('neoclip')
vim.keymap.set('n', '<leader>c', ':Telescope neoclnvim-treesitter/nvim-treesitter-contextip<CR>')

-- treesitter-context
require('treesitter-context').setup {
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context()
end, { silent = true })

-- mini-surround
require('mini.surround').setup()

-- auto-session
require("auto-session").setup {
    log_level = "error",

    cwd_change_handling = {
        restore_upcoming_session = true,   -- already the default, no need to specify like this, only here as an example
        pre_cwd_changed_hook = nil,        -- already the default, no need to specify like this, only here as an example
        post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh()   -- refresh lualine so the new session name is displayed in the status bar
        end,
    },
}

-- telescope select
require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        }
    }
}
require("telescope").load_extension("ui-select")

-- attempt
require('attempt').setup()
require('telescope').load_extension 'attempt'
local attempt = require('attempt')

vim.keymap.set('n', '<leader>an', attempt.new_select, { silent = true })       -- new attempt, selecting extension
vim.keymap.set('n', '<leader>ai', attempt.new_input_ext, { silent = true })    -- new attempt, inputing extension
vim.keymap.set('n', '<leader>ar', attempt.run, { silent = true })              -- run attempt
vim.keymap.set('n', '<leader>ad', attempt.delete_buf, { silent = true })       -- delete attempt from current buffer
vim.keymap.set('n', '<leader>ac', attempt.rename_buf, { silent = true })       -- rename attempt from current buffer
vim.keymap.set('n', '<leader>al', ':Telescope attempt<CR>', { silent = true }) -- search through attempts

-- FTerm
require("FTerm").setup({
    dimensions = {
        height = 0.85,
        width = 0.85,
    },
    border = 'double'
})
vim.keymap.set('n', '<A-z>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<A-z>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- telescope-file-browser
require("telescope").setup {
    extensions = {
        file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            -- mappings = {
            --   ["i"] = {
            --     -- your custom insert mode mappings
            --   },
            --   ["n"] = {
            --     -- your custom normal mode mappings
            --   },
            -- },
        },
    },
}
require("telescope").load_extension "file_browser"
vim.api.nvim_set_keymap(
    "n",
    "<space>pv",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)

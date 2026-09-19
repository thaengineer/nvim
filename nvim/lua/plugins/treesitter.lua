return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "bash",
            "json",
            "kusto",
            "markdown",
            "powershell",
            "python",
            "regex",
            "sql",
            "xml",
            "yaml"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true }
    },
    config = function(_, opts)
        -- master branch: nvim-treesitter.configs.setup
        -- main branch (Lazy default now): that module is gone
        local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
        if configs_ok then
            configs.setup(opts)
        else
            local ts = require("nvim-treesitter")
            if type(ts.setup) == "function" then
                ts.setup({})
            end
            if type(ts.install) == "function" and opts.ensure_installed then
                pcall(ts.install, opts.ensure_installed)
            end
        end

        pcall(vim.treesitter.language.register, "powershell", "ps1")
        pcall(vim.treesitter.language.register, "powershell", "psm1")
        pcall(vim.treesitter.language.register, "powershell", "psd1")
    end,
}

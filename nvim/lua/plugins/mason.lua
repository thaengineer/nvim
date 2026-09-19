return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            }
        },
        "neovim/nvim-lspconfig"
    },
    opts = {
        ensure_installed = {
            "bashls",
            "powershell_es",
            "pyright"
        }
    }
}

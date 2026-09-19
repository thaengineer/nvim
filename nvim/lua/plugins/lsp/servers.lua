return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
            callback = function(ev)
                local bufopts = { noremap = true, silent = true, buffer = ev.buf }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            end,
        })

        vim.lsp.config("bashls", {
            capabilities = capabilities,
            filetypes = { "sh", "bash", "zsh" },
        })

        vim.lsp.config("pyright", {
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                    },
                },
            },
        })

        -- PowerShell Editor Services.
        -- The language *server* prefers pwsh (PS 7+) when present, but still
        -- provides highlighting, completion, hover, and diagnostics for
        -- Windows PowerShell 5.1 scripts (.ps1 / .psm1 / .psd1).
        local function first_executable(cmds)
            for _, cmd in ipairs(cmds) do
                if vim.fn.executable(cmd) == 1 then
                    return cmd
                end
            end
            return nil
        end

        -- Prefer Windows PowerShell 5.1 as the *script* runtime when editing
        -- 5.1-targeted code. PSES itself still launches via pwsh if available.
        local ps51 = first_executable({
            "powershell.exe",
            "powershell",
        })
        local pwsh = first_executable({
            "pwsh.exe",
            "pwsh",
        })

        local powershell_settings = {
            powershell = {
                enableProfileLoading = false,
                scriptAnalysis = { enable = true },
                codeFormatting = {
                    preset = "OTBS",
                    useCorrectCasing = true,
                    whitespaceAroundOperator = true,
                    whitespaceAfterSeparator = true,
                    ignoreOneLineBlock = true,
                },
            },
        }

        if ps51 then
            powershell_settings.powershell.powerShellDefaultVersion = "Windows PowerShell (x64)"
        end

        local ps_cfg = {
            capabilities = capabilities,
            filetypes = { "ps1", "psm1", "psd1", "powershell" },
            settings = powershell_settings,
            -- Mason supplies cmd / bundle_path.
            cmd_env = {
                POWERSHELL_TELEMETRY_OPTOUT = "1",
            },
        }

        -- If only 5.1 exists (no pwsh), point PSES at powershell.exe so the
        -- server can still start on Windows boxes without PS 7.
        if ps51 and not pwsh then
            ps_cfg.shell = ps51
        elseif pwsh then
            ps_cfg.shell = pwsh
        end

        vim.lsp.config("powershell_es", ps_cfg)

        vim.lsp.enable({ "bashls", "pyright", "powershell_es" })
    end,
}

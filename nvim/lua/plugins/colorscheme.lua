return {
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        lazy     = false,
        priority = 1000,
        opts     = {
            flavour    = "macchiato",
            lsp_styles = {
                underlines = {
                    errors      = { "undercurl" },
                    hints       = { "undercurl" },
                    warnings    = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            integrations = {
                cmp                = true,
                gitsigns           = true,
                indent_blankline   = { enabled = true },
                lualine            = true,
                mason              = true,
                neo_tree           = true,
                telescope          = true,
                treesitter         = true,
                treesitter_context = true,
                which_key          = true,
            }
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin-macchiato")
        end
    },
    {
        "bjarneo/aether.nvim",
        branch   = "v3",
        name     = "aether",
        lazy     = false,
        priority = 900,
        opts     = {
            transparent = false,
            colors = {
                -- backgrounds
                bg         = "#0d0d0d", -- editor background
                dark_bg    = "#0d0d0d", -- sidebars, statusline
                darker_bg  = "#0d0d0d", -- darkest panels
                lighter_bg = "#fdfdfd", -- cursorline / UI highlight

                -- foregrounds
                fg        = "#ffffff", -- default text
                dark_fg   = "#ececec", -- secondary / inactive text
                light_fg  = "#ffffff", -- lighter text
                bright_fg = "#ffffff", -- brightest text
                muted     = "#fdfdfd", -- comments, line numbers, borders

                -- accents
                red     = "#a4a4a4", -- errors, deletions
                orange  = "#ffb74d", -- numbers, constants, git changes "#fd971f"
                yellow  = "#ffb74d", -- types, classes, warnings "#cecece"
                green   = "#b6b6b6", -- strings, additions
                cyan    = "#b0b0b0", -- regex, hints, special
                blue    = "#ffcc80", -- keywords, info "#8d8d8d"
                purple  = "#9b9b9b", -- storage, tags
                magenta = "#9b9b9b", -- alias for purple
                brown   = "#7d5440", -- escape sequences (\n, \t)

                -- bright variants (higher-contrast text on bg)
                bright_red     = "#c46e5a",
                bright_yellow  = "#e0b87a",
                bright_green   = "#7eb89a",
                bright_cyan    = "#b39ddb", -- "#7ebcbe"
                bright_blue    = "#7aaac2",
                bright_purple  = "#b39ddb", -- "#a68eba"
                bright_magenta = "#b39ddb", -- "#a68eba"

                -- aliases / UI
                accent               = "#fd971f", -- primary accent
                cursor               = "#ffffff", -- cursor
                foreground           = "#ffffff", -- terminal fg alias
                background           = "#0d0d0d", -- terminal bg alias
                selection            = "#2c3040", -- visual selection
                selection_foreground = "#ffffff", -- selected text
                selection_background = "#4a5366", -- selection background
            },
            on_highlights = function(hl, colors)
                hl.Number       = { fg = colors.orange }
                hl.Constant     = { fg = colors.orange }
                hl["@number"]   = { fg = colors.orange }
                hl["@constant"] = { fg = colors.orange }
            end,
        },
        config = function(_, opts)
            require("aether").setup(opts)
        end
    }
}

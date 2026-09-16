return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons", -- or "nvim-mini/mini.icons"
    },
    opts = {},
    keys = {
        { "<leader>md", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
}

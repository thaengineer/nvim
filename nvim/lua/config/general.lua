-- General Settings
vim.g.mapleader = " "
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "utf-16le", "cp1252", "latin1" }
vim.opt.hidden = true
vim.opt.wildmenu = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.autoread = true
vim.opt.history = 1000
vim.opt.modeline = false

-- Interface
vim.opt.number = true
vim.opt.scrolloff = 6
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.formatoptions:remove("cro")
vim.opt.formatoptions:append("qrn1")
vim.opt.whichwrap:append("<,>,[,]")

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Tabs and Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Clipboard & Mouse
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "n"

-- Performance
vim.opt.lazyredraw = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 300

-- Status Line
vim.opt.laststatus = 2
vim.opt.ruler = true

-- Undo and Backups
local undodir = vim.fn.stdpath("config") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Bash / Python / PowerShell FileType
vim.filetype.add({
    extension = {
        sh = "bash",
        bash = "bash",
        zsh = "bash",
        py = "python",
        pyi = "python",
        ps1 = "ps1",
        psm1 = "ps1",
        psd1 = "ps1",
        pssc = "ps1",
        psrc = "ps1",
    },
    filename = {
        [".bashrc"] = "bash",
        [".bash_profile"] = "bash",
        [".zshrc"] = "bash",
        [".zprofile"] = "bash",
        ["bashrc"] = "bash",
        ["zshrc"] = "bash",
        ["Microsoft.PowerShell_profile.ps1"] = "ps1",
        ["profile.ps1"] = "ps1",
    },
    pattern = {
        [".*%.ps1%.xml"] = "ps1",
    },
})

-- Only set UTF-8 encoding on modifiable buffers
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function()
        if vim.bo.modifiable then
            vim.bo.fileencoding = "utf-8"
        end
    end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.sh", "*.bash", "*.zsh", "*.py", "*.pyi", "*.ps1", "*.psm1", "*.psd1" },
    callback = function()
        if vim.bo.modifiable and not vim.bo.readonly then
            vim.cmd([[ %s/\s\+$//e ]])
        end
    end
})

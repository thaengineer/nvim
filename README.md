# Neovim config

Lazy.nvim setup with Treesitter, Mason, nvim-cmp, and LSP.

Languages wired in this config:

| Language | Highlight | LSP | Completion |
|---|---|---|---|
| Bash / sh / zsh | Treesitter `bash` | `bashls` | nvim-cmp via LSP |
| Python | Treesitter `python` | `pyright` | nvim-cmp via LSP |
| PowerShell 5.1 (`.ps1` / `.psm1` / `.psd1`) | Treesitter `powershell` | `powershell_es` | nvim-cmp via LSP |
| JSON, YAML, XML, SQL, Markdown, Regex | Treesitter | — | buffer / path |

Leader is `<Space>`.

## Layout

```
nvim/
  init.lua
  lua/config/     general, keymap, lazy bootstrap
  lua/plugins/    lazy specs
  lua/plugins/lsp/servers.lua
```

This repo root contains a `nvim/` directory. Copy **that inner folder** to your Neovim config path, not the repo root.

| OS | Config path |
|---|---|
| Linux | `~/.config/nvim` |
| macOS | `~/.config/nvim` |
| Windows | `%LOCALAPPDATA%\nvim` |

## Common requirements (all platforms)

- Neovim **0.11+** (this config uses `vim.lsp.config` / `vim.lsp.enable`)
- Git
- `curl` + `tar`
- A C compiler (Treesitter parsers are compiled from grammar source on the current `nvim-treesitter` `main` branch)
- **tree-sitter CLI 0.26.1+** on `PATH` (not the library-only package)
- Node.js + npm (Mason packages `bash-language-server` and `pyright`)
- Python 3 (runtime for scripts you edit; pyright itself is a Node package)

Verify after install:

```text
nvim --version
git --version
curl --version
tar --version
tree-sitter --version
node --version
```

In Neovim:

```text
:checkhealth
:checkhealth nvim-treesitter
:checkhealth mason
```

---

## Linux

### Compiler and CLI

Debian / Ubuntu:

```bash
sudo apt update
sudo apt install -y git curl tar build-essential unzip
```

Fedora:

```bash
sudo dnf install -y git curl tar gcc gcc-c++ make unzip
```

Arch / CachyOS:

```bash
sudo pacman -S --needed git curl tar base-devel unzip
```

tree-sitter CLI — pick one:

```bash
# cargo (reliable version)
cargo install tree-sitter-cli

# Arch
sudo pacman -S tree-sitter-cli

# do not rely on npm for the CLI; nvim-treesitter docs want the native binary
```

Confirm `tree-sitter` is on `PATH` (`~/.cargo/bin` if you used cargo).

### Neovim

```bash
# Arch
sudo pacman -S neovim

# Ubuntu 24.04+ often ships an older nvim; use the official PPA or a tarball
# if `nvim --version` is below 0.11
```

### Node (for Mason LSPs)

```bash
# Arch
sudo pacman -S nodejs npm

# Debian/Ubuntu (or use nvm / fnm)
sudo apt install -y nodejs npm
```

### Optional: PowerShell LSP on Linux

`powershell_es` wants **PowerShell 7** (`pwsh`) to host the language server. Script files can still be 5.1-targeted.

```bash
# Arch AUR: powershell / powershell-bin
# Microsoft package repos: https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-linux
pwsh --version
```

Without `pwsh`, Treesitter highlighting still works; the PowerShell LSP client will not attach.

---

## macOS

Xcode Command Line Tools (clang, make, git):

```bash
xcode-select --install
```

Homebrew packages:

```bash
brew install neovim git curl node
brew install tree-sitter-cli
```

`brew install tree-sitter` is the **library** only. You need `tree-sitter-cli` so `tree-sitter` exists on `PATH`.

Confirm:

```bash
tree-sitter --version    # 0.26.1 or newer
which tree-sitter        # usually /opt/homebrew/bin/tree-sitter on Apple Silicon
```

If Neovim cannot see the binary, Homebrew is not on the GUI `PATH`. Launch Neovim from a terminal that has `/opt/homebrew/bin` (Apple Silicon) or `/usr/local/bin` (Intel), or add that dir to the path Neovim inherits.

Optional PowerShell 7 for the LSP host:

```bash
brew install powershell
pwsh --version
```

---

## Windows

Use a native Neovim build (not the Windows Store stub if you can avoid it).

### Compiler

Treesitter compile needs a C compiler visible to Neovim.

Option A — Visual Studio Build Tools (MSVC):

- Install “Desktop development with C++”
- Open Neovim from a **Developer PowerShell / x64 Native Tools** prompt, or put `cl.exe` on `PATH`

Option B — MinGW via winget / Chocolatey:

```powershell
winget install Git.Git Neovim.Neovim OpenJS.NodeJS.LTS
# compiler:
winget install BrechtSanders.WinLibs.POSIX.UCRT
```

Restart the terminal after installs so `PATH` refreshes.

### tree-sitter CLI

```powershell
winget install TreeSitter.tree-sitter
# or
cargo install tree-sitter-cli
```

Confirm in the **same** shell you start Neovim from:

```powershell
tree-sitter --version
where.exe tree-sitter
```

### PowerShell 5.1 vs 7

Windows already has **Windows PowerShell 5.1** (`powershell.exe`). That is enough to *edit* 5.1 scripts.

PowerShell Editor Services (the LSP) is more reliable when **PowerShell 7** (`pwsh.exe`) is installed to *run the server*:

```powershell
winget install Microsoft.PowerShell
pwsh --version
```

This config:

- prefers `pwsh` to launch PSES if it exists
- falls back to `powershell.exe` if 7 is missing
- sets the editor default version to Windows PowerShell (x64) when 5.1 is on `PATH`, so analysis stays 5.1-oriented

### Config path

```powershell
# typical
$env:LOCALAPPDATA\nvim
# example
C:\Users\<you>\AppData\Local\nvim
```

The inner `nvim\` tree from this repo goes there (`init.lua` must sit directly in that folder).

---

## Install this config

```bash
git clone <your-repo-url> /tmp/nvim-dot
# Linux / macOS
rsync -a /tmp/nvim-dot/nvim/ ~/.config/nvim/
# Windows (PowerShell)
# Copy-Item -Recurse .\nvim\* $env:LOCALAPPDATA\nvim\
```

First launch:

```text
nvim
:Lazy sync
:Mason
```

Mason should install:

- `bash-language-server` (`bashls`)
- `pyright`
- `powershell-editor-services` (`powershell_es`)

Treesitter parsers (needs the CLI + compiler):

```text
:TSInstall powershell bash json python yaml markdown xml sql regex
```

`kusto` is listed in the spec but the grammar is often missing or unmaintained on `nvim-treesitter` `main`. Safe to ignore if that install fails.

Confirm:

```text
:checkhealth nvim-treesitter
:LspInfo
```

Open a `.ps1` and wait for `powershell_es` to attach. Completion uses nvim-cmp (`<C-Space>` to force, `<CR>` to accept).

## PowerShell notes

- Filetypes: `.ps1`, `.psm1`, `.psd1`, `.pssc`, `.psrc`
- Highlighting does **not** need the LSP, only the `powershell` parser
- Completion, hover (`K`), definition (`gd`), rename (`<leader>rn`), code actions (`<leader>ca`) need `powershell_es` attached
- PSES is a .NET app hosted by `pwsh` (preferred) or `powershell.exe`
- Profile loading is disabled in the LSP settings so the server starts faster and does not run your profile as a side effect

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `module 'nvim-treesitter.configs' not found` | Old setup API on new `main` branch | Use the dual-API `treesitter.lua` in this repo |
| `ENOENT ... 'tree-sitter'` on `:TSInstall` | CLI missing or not on Neovim's `PATH` | Install `tree-sitter-cli`, restart the terminal, `:checkhealth nvim-treesitter` |
| Parser build fails after CLI is present | No C compiler | Linux: `build-essential` / `base-devel`. macOS: `xcode-select --install`. Windows: MSVC or MinGW |
| Mason package install fails | Node missing | Install Node 18+ and ensure `npm` is on `PATH` |
| `powershell_es` never attaches | No `pwsh` / PSES not installed | `:Mason` → install `powershell-editor-services`; install PowerShell 7 |
| Highlight works, no completion | LSP not attached | `:LspInfo` on a `.ps1`; check Mason and `pwsh` |
| macOS GUI nvim cannot find `tree-sitter` | Homebrew not in GUI `PATH` | Launch from Terminal.app / iTerm, or add `/opt/homebrew/bin` to the path Neovim inherits |

Do not install the tree-sitter CLI with `npm install -g tree-sitter-cli` unless nothing else works. The plugin maintainers want the native binary from cargo, Homebrew (`tree-sitter-cli`), or the system package.

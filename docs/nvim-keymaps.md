# Neovim keymaps

Custom keymaps live in `.config/nvim/lua/config/keymaps.lua`.

## Window navigation

- `Ctrl+h/j/k/l` moves between splits in normal mode (LazyVim default) and in visual mode (added in `keymaps.lua`).
- In visual mode the mapping runs `<C-w>{h,j,k,l}` with no `<Esc>`. This lets you select lines, jump to the Claude split, and still send the selection.
- Moving to another window ends visual mode. `claudecode.nvim` records the selection as you leave the window.

## Find directory

- `<leader>fd` (in `.config/nvim/lua/plugins/snacks.lua`) opens a Snacks picker of directories.
- On confirm it focuses Neo-tree, moves the cursor onto the chosen directory, and expands it.

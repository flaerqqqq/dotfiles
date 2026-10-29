# Themes

One command switches the theme for Ghostty, Neovim, tmux, fzf and ledge together.

```
theme                 # fzf picker (plain list if no tty or no fzf)
theme <id>            # apply directly, e.g. theme gruvbox-dark-hard
```

Current themes:
- `kanagawa-dragon`, `kanagawa-wave`
- `atom-one-dark` (transparent nvim background)
- `ayu-mirage` (transparent nvim background)
- `github-dark` (transparent nvim background)
- `gruvbox-dark`, `gruvbox-dark-hard`
- `kanso-zen`, `kanso-ink`, `kanso-mist` (transparent nvim background, so Ghostty's background shows through)

## How it works

- `scripts/theme` writes the current id to `${XDG_STATE_HOME:-~/.local/state}/theme/current` and points `~/.config/ghostty/theme-active.conf` at the matching Ghostty theme file.
- Ghostty includes `theme-active.conf` via `config-file = ?theme-active.conf` in `.config/ghostty/config.ghostty`. Reload with `ctrl+shift+,` or restart.
- tmux: `scripts/theme` symlinks `~/.config/tmux/theme-active.conf` to `.config/tmux/themes/<id>.conf`, which sets the `tmux-ukiyo` theme. If a tmux server is running, the switcher reloads it. `tmux.conf` sources the active file before the plugins load.
- Neovim reads the state file on start (`lua/config/theme.lua`, applied through the `LazyVim` `opts.colorscheme` hook in `lua/plugins/colorscheme.lua`). It re-checks on `FocusGained`, so a running session switches when you focus it. tmux needs `focus-events on` for this.

In Neovim, `<leader>uC` opens a theme picker (replacing LazyVim's colorscheme picker, which did not persist). Selecting a theme changes Neovim only and saves the choice to `${XDG_STATE_HOME:-~/.local/state}/theme/nvim`, which takes precedence over `current` for Neovim. Ghostty, tmux and fzf are untouched. Running `theme` clears this override, so Neovim follows the global theme again.

## Files

- `.config/ghostty/themes/<id>.conf`: one line, `theme = <Ghostty theme name>`. Names come from `ghostty +list-themes`.
- `.config/nvim/lua/plugins/themes/<id>.lua`: lazy.nvim spec for the theme plugin. It must set `colorscheme` to the vim colorscheme name, and optionally `background` (`dark` by default, or `light`) and `setup`, a function called after the plugin loads. Use `setup` for per-theme options when several themes share one plugin, such as the gruvbox variants. Do not use `opts` for those, since lazy.nvim merges `opts` across specs. Imported via `{ import = "plugins.themes" }` in `lua/config/lazy.lua`.
- `.config/tmux/themes/<id>.conf`: sets `@ukiyo-theme` to a tmux-ukiyo theme and variant, such as `kanagawa/dragon`. It also sets the status bar background and `popup-style` to the theme's Ghostty background, so bar and popups match the terminal. Themes that exist in ukiyo (kanagawa/dragon, gruvbox dark) use the built-in variant colors, and only `bg-bar` and `popup-style` are overridden with the Ghostty background, so the bar blends with the terminal. `gruvbox-dark-hard` is the exception: all its semantic colors come from the Ghostty Gruvbox Dark Hard palette. The other themes (Kanso) use `kanagawa/wave` as the base and override the semantic colors from the Ghostty palette: `text` = foreground, `bg-bar` and `popup-style` = background, `bg-pane` = palette 0, `highlight` and `selection` = palette 8 blended 25% toward the background (palette 8 alone is too bright for the selected window), `info` = 6, `accent` = 4, `notice` = 3, `error` = 1, `muted` = 7, `alert` = 11. The switcher clears the previous theme's overrides before reloading tmux. `tmux.conf` sources the active theme file both before and after tpm. The first source sets the ukiyo options, and the second applies window formats, since ukiyo overwrites them when it loads. `gruvbox-dark-hard` uses this to color only the active window (palette 6 aqua, `#689d6a`) with a bold style. Its semantic colors are overridden from the Ghostty Gruvbox Dark Hard palette, so `accent` (session name) is aqua too.
- `.config/fzf/themes/<id>.conf`: fzf `--color` lines, generated from the Ghostty palette. `background` and `foreground` are used directly, `hl` and `header` use palette 6, `prompt` and `label` use 4, `pointer` uses 1, `marker` and `spinner` use 2. `info` and `border` are blended between background and palette 8, and `bg+` is blended between background and foreground.
- `.config/fzf/config`: fzf layout options, no colors. The switcher writes `~/.config/fzf/active` as this file plus the theme's colors, and `.zshenv` points `FZF_DEFAULT_OPTS_FILE` at it. New shells pick up the change; open shells keep the old colors.
- `.config/ledge/themes/<id>.json`: the `theme` and `theme_colors` keys that ledge reads from its `config.json`. The Kanso themes map to ledge's built-in `zen`, `ink` and `mist`. The others use the built-in `ink` plus a `theme_colors` override of all 16 tokens, generated from the Ghostty palette: `background` and `surface` = background, `text` and `selection_fg` = foreground, `text_muted`, `session_none`, `missing` and `connector` = foreground blended 30% toward the background, `border` = background blended 25% toward the foreground, `selection_bg` = 20%, `accent` = 4, `success` and `session_active` = 2, `warning` = 3, `error` = 1, `path` = 6. The switcher merges these two keys into `~/.config/ledge/config.json` with `jq`, keeping its other keys (`search_paths`, `default_profile`). That file is not in this repo. Ledge reads it on launch, so open ledge windows keep the old theme. Without `jq` or the config file, the ledge step is skipped.
- `scripts/theme`: the switcher.

## Adding a theme

1. Create `.config/ghostty/themes/<id>.conf` with `theme = <Ghostty name>`.
2. Create `.config/nvim/lua/plugins/themes/<id>.lua` with the plugin spec and `colorscheme = "<vim name>"`.
3. Create `.config/tmux/themes/<id>.conf` with `set -g @ukiyo-theme "<theme>/<variant>"`.
4. Create `.config/fzf/themes/<id>.conf` with the `--color` lines (see the palette mapping above).
5. Create `.config/ledge/themes/<id>.json` with `theme` (and `theme_colors` unless a built-in ledge theme fits).
6. Link the new files: `./install.sh --only .config/ghostty/themes,.config/nvim/lua/plugins/themes,.config/tmux/themes,.config/fzf,.config/ledge,scripts`.
7. Run `theme <id>` to check all sides.

# tds — tmux dev session launcher

`tds` (`scripts/tds`) opens a project directory as a tmux session. It is similar to
tmux-sessionizer: pick a project, get a session named after it, and switch to or
attach to that session. On top of that it can build a predefined window layout
(a "profile") and optionally launch an editor.

## Files

| Path | Purpose |
| --- | --- |
| `scripts/tds` | The script (Bash). |
| `.config/tds/config.json` | Main config: search paths. Symlinked to `~/.config/tds/config.json`. |
| `.config/tds/profiles/<name>.json` | Window layout profiles, one file per profile. |
| `~/.cache/tds/history` | Recent project history, newest first, max 50 lines. Created at runtime. |

`XDG_CONFIG_HOME` and `XDG_CACHE_HOME` are honored. If `config.json` is missing, the
script creates it with `"search_paths": ["~/projects"]`.

## Dependencies

- Required: `tmux`, `jq`. The script exits if either is missing.
- Optional, by mode: `fzf` (for `-H` and `-f`), `yazi` (for `-y`), and the editor
  you pass to `-c`, `-i`, or `-e`.

## Usage

```
tds [DIRECTORY] [OPTIONS]
```

Selection (one mode at a time; the last one parsed wins, see "Selection precedence"):

| Flag | Behavior |
| --- | --- |
| `DIRECTORY` | Open this path. Default is `$PWD`. |
| `-H`, `--history` | Pick from history with fzf. |
| `-f`, `--find` | Pick from the first level of every `search_paths` entry with fzf. |
| `-y`, `--yazi` | Pick a directory in yazi; the directory yazi is in on exit is used. |
| `-s`, `--sessions` | Pick from tds-managed tmux sessions. Enter switches, `ctrl-r` recreates the picked session, `ctrl-x` kills it. |

Workspace and editor:

| Flag | Behavior |
| --- | --- |
| `-p`, `--profile <name>` | Use `profiles/<name>.json`. Error if the file is missing or has no `windows` array. |
| `--no-profile` | Ignore `default_profile` and any `-p`; use the single-window layout. |
| `-c`, `--code` | Launch `code <dir>` in the background, only when the session is created. |
| `-i`, `--idea` | Launch `idea <dir>` in the background, only when the session is created. |
| `-e`, `--editor <cmd>` | Launch `<cmd> <dir>` in the background, only when the session is created. |

`tds` only manages sessions tagged with the tmux session option `@tds_managed=1`, which it sets when it builds a session.
Sessions created outside `tds` are ignored by `-f`, `-H`, `-s`, `-l` and `-k`. A session created before this tag existed
can be adopted with `tmux set-option -t <name>: @tds_managed 1`.

`-f` and `-H` mark directories that already have a managed session, showing the session name and the profile it was created with
(stored in the tmux session option `@tds_profile`).

Session management:

| Flag | Behavior |
| --- | --- |
| `-l`, `--list` | List tds-managed sessions (name, window count, attached state, path). Exits without touching anything. |
| `-k`, `--kill <name\|dir>` | Kill a session by exact name, or the session for a directory (same naming as `tds`). |
| `--recreate` | If the session exists, kill it and rebuild it, so a changed profile takes effect. Without `-p`, it uses the profile recorded in the session's `@tds_profile` (`basic` means the single-window layout), falling back to `default_profile` if that profile is missing. |

`--recreate` kills running processes in that session, so use it deliberately. When run from inside
that session, `tds` builds the replacement under a temporary name, switches you to it, and then
renames it to the original name.

Utility: `--clean` clears history, `-h`/`--help` prints help.

Examples:

```
tds                 # session for the current directory, 1-window layout
tds -f -p dev       # fzf-pick a project, apply the "dev" profile
tds -H              # pick from recent projects
tds ~/dev/projects/api -c -p dev
```

## Control flow

1. Check that `tmux` and `jq` exist.
2. Create the config and profiles directories if needed.
3. Read `search_paths` from `config.json` with `jq`, expanding `~` and `$VARS` via `eval`.
4. Parse arguments.
5. Resolve the profile: `--no-profile` ends the search; otherwise `-p` (must exist and be valid,
   else exit 1), otherwise `default_profile` (missing or invalid prints a warning and falls back),
   otherwise the single-window layout.
6. Resolve the target directory:
   - `-H`: fzf over the history file.
   - `-f`: fzf over the directories listed by `find` in each search path (depth 1, hidden directories skipped).
   - `-y`: run yazi and read its `--cwd-file`.
   - none of the above: `DIRECTORY`, or `$PWD`.
7. Resolve the absolute path and add it to history (dedupe, prepend, cap at 50).
8. Compute the session name: `<basename with dots replaced by _>-<first 4 hex of md5(abs path)>`.
   The hash keeps same-named projects in different places apart.
9. If an editor was requested, start it detached with `setsid` and wait 0.2s.
10. Create the session if it does not exist (`build_session`).
11. Attach or switch:
    - Not in tmux and no tmux server running: create and attach.
    - Not in tmux, server running: create if needed, then attach.
    - Inside tmux: create if needed, then `switch-client`.

### Selection precedence

Flags are applied in the order they appear, but the mode check that follows is fixed:
`-H` is checked first, then `-f`, then `-y`. If both `-H` and `-f` are given, `-H` wins.
A positional `DIRECTORY` is ignored when any selection mode is active.

## tmux popups

Defined in `.config/tmux/tmux.conf` (prefix is `C-Space`):

| Key | Action |
| --- | --- |
| `prefix + f` | `tds -f` in an 80%×80% popup. Overrides tmux's default find-window. |
| `prefix + F` | `tds -s` in an 80%×80% popup. |

The popup closes when the picker exits. Errors printed by `tds` are lost when it closes.

## Window layouts (profiles)

A profile is JSON with a `windows` array. Each entry has:

```json
{ "name": "󰈚 Code", "command": "nvim ." }
```

- `name` becomes the tmux window name.
- `command` is optional. An empty string means a plain shell.
- The first window is created with `new-session`, the rest with `new-window`, all with
  the target directory as `cwd`.
- Window 1 is selected at the end.

Profile precedence:

1. `--no-profile`: single window, nothing else is checked.
2. `-p <name>`: that profile. Missing or invalid is an error.
3. `default_profile` from `config.json`. Missing or invalid prints a warning and falls back.
4. Built-in single-window layout: one window named `󰞷 Terminal`, no file needed.

A profile is valid when its `windows` field is an array.

Profiles only apply when a session is **created**. If the session already exists,
`-p` has no effect on an existing session unless `--recreate` is given.

The current `dev` profile has five windows: Code (`nvim .`), Terminal, AI, Run, Infra.

## Configuration reference

`config.json`:

```json
{
  "default_profile": "dev",
  "search_paths": [
    "~/dev/projects"
  ]
}
```

- `search_paths` (array of strings): used by `-f`. Each entry is scanned at depth 1.
  Missing paths are silently skipped.
- `default_profile` (string, optional): name of a file in `profiles/` used when `-p` is not given.

## Open issues and gaps

Found while writing this doc. Ordered roughly by impact.

1. **`--find` help says it scans submodules; it doesn't.** Only depth-1 directories
   of `search_paths` are listed. Submodules would need `git submodule status` or a
   `.gitmodules` read.
2. **`eval` on config values.** `eval path="$path"` runs whatever is in
   `search_paths`. Fine for a personal dotfile, but a config value with `$(...)`
   would execute. Safer option: expand only a leading `~` and `$HOME`.
3. **`-p` with no argument.** `shift 2` runs with an empty `$2`, which gives an odd
   error about `.json`. Should check that a value is present.
4. **Yazi temp file.** The `mktemp` file in `/tmp` is removed after yazi returns, but
   is left behind if the script is interrupted (Ctrl-C) while yazi is open. A `trap` would fix it.
5. **`tmux_running=$(pgrep tmux)`** matches any process named `tmux`, including
   `tmux-sessionizer` or other wrappers. `tmux has-session` or `tmux info` would be
   more accurate. Low impact, since both branches end in the same place.

## Manual testing checklist

- `tds` from a project directory outside tmux, and inside tmux.
- `tds -H` with an empty history, then with entries; `--clean` afterwards.
- `tds -f` with a missing search path, and with the default path.
- `tds -p dev` and `tds -p missing` (should error).
- Run it twice on the same path: the second call should only switch or attach.
- Two projects with the same basename in different places: sessions must differ.
- `tds -c` and `tds -e <cmd>` with the editor missing: the failure should be visible.

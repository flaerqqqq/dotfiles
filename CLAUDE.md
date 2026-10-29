# Dotfiles

Personal dotfiles, symlinked into $HOME by `install.sh`. Files under `scripts/` are linked flatly into `~/.local/bin`.

## Docs must stay current

Whenever something changes in this project, update the docs in the same change:
- Add or change a feature, script, config, or keybinding: document it under `docs/`.
- Add a new doc: link it from `docs/README.md`.
- Remove or rename something: remove or fix every doc that mentions it.

Do not leave docs describing behavior that no longer exists.

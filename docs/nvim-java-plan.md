# Neovim Java setup: IntelliJ IDEA parity plan

Goal: a Neovim setup for Java development that covers the workflow you use in IntelliJ IDEA.
This is a task list, not a spec. Each item says what IntelliJ does, what the Neovim setup has
now, and what is missing. Items marked **verify** depend on `jdtls` behavior that I haven't
checked in a running session.

## Status legend

- **Done**: works in the current config.
- **Partial**: some of it works, or the keymap or wiring is missing.
- **Missing**: nothing in the config yet.

## Current state (from the config)

- LazyVim base with `nvim-java` (runs `jdtls`), `nvim-dap`, `spring-boot.nvim`,
  `nvim-treesitter` with textobjects, `blink.cmp`, `snacks.nvim` pickers, `telescope`,
  `neo-tree`, `trouble`, `todo-comments`, `gitsigns`, `conform` (LazyVim), `nvim-lint`,
  `which-key`, `flash`, `mini.ai`, `nvim-various-textobjs`.
- Formatting: `<leader>cf` formats Java through `jdtls` (Eclipse style). Format on save is off
  (`vim.g.autoformat = false`).
- Java helpers: `<leader>jb` (build workspace), `<leader>ri` (resolve imports),
  `<leader>oi` (organize imports), `<leader>fj` (class index across jars).
- GitHub keys removed. `git.lua` disables most LazyVim `<leader>g*` keys.
- IntelliJ-style keymap block was removed. No refactoring keymaps exist now.

---

## 1. Refactoring

IntelliJ's most-used refactorings (JetBrains docs): Safe Delete, Copy/Move, Extract Method,
Extract Constant, Extract Field, Extract Parameter, Introduce Variable, Rename, Inline,
Change Signature. The docs also mention Encapsulate Fields, Move Static Members, Extract
Delegate, Extract Interface, and Extract Superclass.

| Task | Status | Notes |
| --- | --- | --- |
| Rename symbol | Partial | LSP rename exists in LazyVim (`<leader>cr`). Keymap is LazyVim's, not IntelliJ's. |
| Extract Method | Missing | `jdtls` code action. **verify** title and whether it works on a range. |
| Extract Variable (Introduce Variable) | Missing | `jdtls` code action. **verify**. |
| Extract Constant | Missing | `jdtls` code action. **verify**. |
| Extract Field | Missing | `jdtls` code action. **verify**. |
| Extract Parameter (Introduce Parameter) | Missing | **verify** whether `jdtls` offers it. |
| Inline (variable, method, constant) | Missing | `jdtls` code action. **verify** per target. |
| Change Signature | Missing | `jdtls` code action. **verify**. Expect a prompt for parameter order. |
| Safe Delete | Missing | No known `jdtls` action. May need an external tool or a manual check of usages first. |
| Copy / Move class or file | Missing | **verify** `jdtls` move support. It may need `workspace/willRenameFiles` handling. |
| Encapsulate fields (getters and setters) | Missing | `jdtls` source action. **verify**. |
| Extract Interface / Superclass | Missing | **verify** whether `jdtls` offers either. |
| Convert anonymous class to lambda | Missing | **verify**. |
| Change method modifiers, convert local to field | Missing | **verify** each. |

Plan: one keymap per refactoring, under `<leader>r`. Use a helper that calls
`vim.lsp.buf.code_action` with a title filter, so each keymap maps to one `jdtls` action.
Commands that aren't `jdtls` code actions (for example Safe Delete) need their own approach.

## 2. Code assistance

| Task | Status | Notes |
| --- | --- | --- |
| Completion | Done | `blink.cmp` with `jdtls` as source. |
| Quick fixes and intentions (lightbulb) | Partial | LazyVim `<leader>ca` runs code actions. No keymap for "show all" vs "quick fix". |
| Inspections and problem list | Partial | Diagnostics and `trouble.nvim` exist. No keymap for inspect-current-problem beyond diagnostics. |
| Parameter name hints | Missing | Turned off in `nvim-java.lua`. Decide whether to enable. |
| Javadoc on hover | Done | LSP hover (`K`). Javadoc generation is missing. |
| Generate (getters, setters, constructor, toString, equals/hashCode) | Missing | `jdtls` source actions. **verify** titles. |
| Override and implement methods | Missing | `jdtls` code actions. **verify**. |
| Surround with (try/catch, if, etc.) | Missing | `jdtls` code actions, plus `nvim-various-textobjs`/`mini` for text surround. |
| Live templates (`sout`, `psvm`, `fori`) | Partial | `friendly-snippets` is installed. Java snippets need checking. Add a Java snippet file if missing. |
| Smart completion | Partial | Blink handles this. Type-based filtering depends on `jdtls`. |
| Import management | Done | `<leader>ri`, `<leader>oi`. |
| Structural search and replace | Missing | Not covered. `grug-far` is installed (text search and replace). |

## 3. Navigation and search

| Task | Status | Notes |
| --- | --- | --- |
| Go to declaration / definition | Done | LazyVim `gd`. |
| Go to implementation | Partial | Mapped to `gi` in the earlier config, now removed. Re-add if wanted. |
| Find usages | Partial | LSP references exist (LazyVim `gr`). |
| Go to type declaration | Partial | LSP. Mapping removed earlier. |
| Type hierarchy | Missing | `jdtls` supports it. **verify** a picker or UI. |
| Call hierarchy | Missing | `jdtls` supports it. **verify**. |
| Go to class / symbol (workspace) | Partial | `snacks` picker exists (`<leader>fj` for jars). |
| File structure popup | Partial | LazyVim symbols (`<leader>cs`, trouble). |
| Recent files | Partial | Snacks recent exists. |
| Recent locations and jumps | Missing | Vim jumplist (`<C-o>`, `<C-i>`) works. No picker. |
| Back and forward navigation | Done | Vim jumplist. |
| Search everywhere | Done | Snacks/telescope. |
| Find in path | Done | Snacks grep. |
| Go to test / test to code | Missing | No mapping for jumping between `Foo` and `FooTest`. |
| Breadcrumbs | Done | `dropbar.nvim`. |

## 4. Project tree and modules

| Task | Status | Notes |
| --- | --- | --- |
| Project tree | Done | `neo-tree`. |
| Module view (multi-module Maven/Gradle) | Missing | No view of modules or build structure. |
| Module picker (open a module as its own session) | Missing | Planned earlier (`tds` with yazi or a module picker). |
| Project structure / dependencies view | Missing | No Maven or Gradle dependency tree. |
| File templates (new class, interface, enum, record) | Done | `template.nvim` and `java-new.lua`. |
| Create new package | Partial | Through neo-tree or the template helper. |

## 5. Build and run

| Task | Status | Notes |
| --- | --- | --- |
| Build project | Partial | `<leader>jb` (`JavaBuildBuildWorkspace`). |
| Run main class | Missing | `nvim-java` run commands exist. No keymaps yet. |
| Maven and Gradle tasks (lifecycle, custom goals) | Missing | No task runner UI. |
| Run configurations (saved run targets) | Missing | IntelliJ's run configurations have no direct equivalent. |
| Spring Boot run | Partial | `spring-boot.nvim` is installed. Run and dashboard keys need checking. |
| Problems from build output | Missing | Quickfix from build output is not wired. |

## 6. Testing

| Task | Status | Notes |
| --- | --- | --- |
| Run test under cursor | Missing | `nvim-java` test commands exist (`java-test` is installed via Mason). No keymap. |
| Run test class | Missing | As above. |
| Run all tests | Missing | As above. |
| Test results UI (tree, pass and fail) | Missing | `neotest` is not installed. |
| Rerun failed tests | Missing | Depends on the test UI. |
| Code coverage | Missing | JaCoCo integration not set up. |
| Jump between test and source | Missing | See the navigation section. |
| Generate test class | Missing | Template support is possible through `template.nvim`. |

## 7. Debugging

| Task | Status | Notes |
| --- | --- | --- |
| Breakpoints (line, conditional) | Partial | `nvim-dap` is installed. Keymaps and conditional breakpoints need wiring. |
| Debug run (application or test) | Missing | `java-debug-adapter` is installed via Mason. Needs a launch config. |
| Step over, into, out | Missing | Keymaps not set. |
| Variables, watches, evaluate | Missing | `nvim-dap-ui` is not installed. |
| Remote debugging (attach) | Missing | Needs a configuration. |
| Hot reload | Missing | Depends on the Java debugger support. **verify**. |
| Exception breakpoints | Missing | Depends on configuration. |
| Threads and heap view | Missing | Depends on `nvim-dap-ui` and related UI. |

## 8. Version control

| Task | Status | Notes |
| --- | --- | --- |
| Gutter signs (changed lines) | Done | `gitsigns`. |
| Hunk stage, reset, preview | Partial | `gitsigns` provides them. Keymaps were removed with the `<leader>g*` cleanup. |
| Blame | Partial | `gitsigns` provides it. No keymap. |
| Diff view with conflict resolution | Missing | No diff UI (for example `diffview.nvim`). |
| Commit and push UI | Missing | Could use `lazygit` or a Snacks git picker. |
| Git log and history | Partial | Snacks has git pickers (no keymap). |
| GitHub integration | Removed | Deliberately removed. |

## 9. Formatting and code style

| Task | Status | Notes |
| --- | --- | --- |
| Format current file | Done | `<leader>cf` through `jdtls` (Eclipse style). |
| Format on save | Done (off) | Off by design. |
| Project-specific style (Spotless or Eclipse XML) | Missing | Planned, not implemented. |
| `.editorconfig` | Partial | Indent and line endings are applied by Neovim and `jdtls`. Trailing whitespace is not trimmed. |
| Organize imports | Done | `<leader>oi`. |
| Lint (Checkstyle or similar) | Missing | `nvim-lint` is installed but has no Java linter configured. |

## 10. XML, config, and other file types

| Task | Status | Notes |
| --- | --- | --- |
| XML editing with schema validation (`pom.xml`, Spring config) | Missing | No XML language server (`lemminx`) configured. |
| YAML, JSON, TOML | Done | LazyVim language extras. |
| Properties files | Missing | No dedicated support. |
| Dockerfile, Terraform | Done | LazyVim language extras. |
| SQL and database tools | Missing | No database client. |

## 11. Tools and terminal

| Task | Status | Notes |
| --- | --- | --- |
| Terminal inside Neovim | Partial | Snacks or LazyVim terminal exists. Needs a check. |
| HTTP client (request files) | Missing | Not configured. |
| Tool windows (run, debug, build) | Missing | No consolidated panel. |
| Plugin and keymap help | Done | `which-key`. |

## 12. Keymap and UX

| Task | Status | Notes |
| --- | --- | --- |
| IntelliJ-style keymap | Missing | Removed. Decide whether to rebuild it per category, or keep LazyVim's. |
| Keymap conflicts | Open | Several IntelliJ keys conflict with LazyVim defaults (`<leader>e`, `<leader>cs`, `<leader>cd`, `<leader>gi`, `<leader>sc`, `<leader>q`). |
| Notifications and progress | Partial | `noice` is installed. |

---

## Priorities

1. **Refactoring keymaps**, one per refactoring, after checking `jdtls` titles (`verify`).
2. **Debugging**: configure `nvim-dap` launch for Java, keymaps for breakpoints and stepping, and add `nvim-dap-ui`.
3. **Testing**: run test under cursor, run class, run all, and a results UI (`neotest` with a Java adapter).
4. **Build and run**: keymaps for run main class and Maven or Gradle tasks.
5. **Generate and override**: keymaps for `jdtls` source actions.
6. **Navigation**: type hierarchy, call hierarchy, and test-to-source jump.
7. **Module view** and the module picker from the `tds` plan.
8. **XML language server** for `pom.xml` and Spring config.
9. **Lint** for Java (Checkstyle or similar) through `nvim-lint`.
10. **Version control**: diff view and commit UI.

## Open questions

- Keymap philosophy: IntelliJ's keys everywhere, or only where they don't conflict with LazyVim?
- Should `jdtls` or an external tool (like Spotless) own project formatting rules?
- Which of the Missing items are in your daily flow, and which can wait?

## Sources

- [IntelliJ IDEA: Refactor source code](https://www.jetbrains.com/help/idea/refactoring-source-code.html)
- [IntelliJ IDEA: Debugging code](https://www.jetbrains.com/help/idea/debugging-code.html)
- [IntelliJ IDEA: Testing](https://www.jetbrains.com/help/idea/testing.html)
- [IntelliJ IDEA: Extract method](https://www.jetbrains.com/help/idea/extract-method.html)
- [IntelliJ IDEA: Extract/Introduce variable](https://www.jetbrains.com/help/idea/extract-variable.html)
- [IntelliJ IDEA keyboard shortcuts](https://www.jetbrains.com/help/idea/mastering-keyboard-shortcuts.html)

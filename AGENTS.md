# AGENTS.md

Personal **dotfiles / tooling-config collection** for macOS (darwin). Not an application: there is **no build, test, or lint pipeline**. Configs are **deployed by manual symlinks** — no install/bootstrap script is tracked (don't invent one); edits are live once the symlinked target changes.

## Environment

- **Nix flake + direnv**. `.envrc` is `use flake`; entering the repo auto-loads `flake.nix`'s `devShell` (run `direnv allow` if `.direnv/` is absent).
- `nix/nix.conf` is the Nix *daemon/client* config (flakes + `nix-command` enabled; `helix.cachix.org` substituter) — **not** the flake. `flake.nix` at root *is* the devshell.
- The devshell provides the language servers that validate edits: **nixd / nil** (Nix), **lua-language-server** (`nvim/`), **vscode-json-languageserver** (JSON configs). Also Rust + QMK toolchains for `flash.sh`.

## Directory map (what each path configures)

- `ghostty/` — Ghostty terminal (`config.ghostty`).
- `helix/` — Helix editor: `config.toml`, `languages.toml`, `.scm` files, `themes/`. (`runtime/` is gitignored / generated.)
- `karabiner/` — Karabiner-Elements (mac). `karabiner.json` is large and app-managed; plus `assets/`, `automatic_backups/`.
- `kgen/` — keymap-generator sources per keyboard (`elora/`, `ferris/`); consumed by `flash.sh`.
- `nvim/` — Neovim (`init.lua`, `lua/`).
- `opencode/` — **this repo's own OpenCode config** (see below).
- `scripts/` — shell helpers; `tmux-session.sh` needs `fd` + `sk` (skim).
- root: `.tmux.conf`, `.zshrc`, `.envrc`, `flake.nix`, `flash.sh`.

## OpenCode config (meta — this repo configures itself)

- OpenCode config lives at **`opencode/opencode.json`** (not repo root). It defines an OpenRouter provider keyed by env `OR_KEY`, **disables the built-in `build` and `plan` agents**, and sets `planner` as the default agent.
- Custom agents: `opencode/agent/{planner,executor,verifier,doc-reader}.md`. Commands: `opencode/command/{plan,verify}.md`. Intended flow: `plan` (read-only planner → human approves) → executor → `verify` (read-only verifier).
- **Load the `customize-opencode` skill before editing anything under `opencode/`** (agents, commands, `opencode.json`).
- In `opencode/`, `package.json`, `package-lock.json`, `bun.lock`, and `node_modules/` are **gitignored** — a local-only install of `@opencode-ai/plugin`. Don't commit them.

## Verification (there is no app pipeline)

- No test/build/lint suite exists. For config edits, rely on the matching LSP from the devshell.
- Flake changes: `nix flake check` and/or `direnv reload` to confirm the devshell still evaluates.
- Pure dotfile/config edits (no flake, no code) need no build step.

## Gotchas

- `.gitignore` deliberately un-tracks `.zshrc`, `/raycast`, `Session.vim`, `/.tmp`, `/.direnv`, `/helix/runtime`. These are local-only; editing them and expecting a commit will fail silently.
- `flash.sh` depends on external CLIs (`qmk`, `kgen`, `sk`) and an external checkout at `$HOME/Documents/projects/qmk_userspace`. It also **hardcodes the keyboard to `splitkb/halcyon/elora/rev2` *after* the skim prompt**, so the interactive selection only affects the `kgen` source path — not the build/flash target.
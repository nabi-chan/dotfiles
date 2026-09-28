# PROJECT KNOWLEDGE BASE

**Updated:** 2026-09-28
**Branch:** main

## OVERVIEW

chezmoi source repo for macOS (Apple Silicon) dotfiles. Core stack is chezmoi templates, zsh/mise/just configs, agent CLI setup (Claude Code, Codex), local app configs, and checked-in font assets. The GitHub repo is public.

## STRUCTURE

```text
./
|-- .chezmoidata/shell.yaml      # zsh aliases, env, PATH entries, zplug plugin data
|-- .chezmoidata/skills.yaml     # skills CLI version + global agent skill deps
|-- .chezmoidata/{claude,mcp}.yaml # Claude settings keys, shared MCP servers
|-- .chezmoiscripts/             # run_onchange_after_* bootstrap scripts (see SCRIPTS)
|-- dot_zprofile.tmpl            # brew shellenv, mise shims, environment exports
|-- dot_zshrc.tmpl               # zplug, PATH, aliases, ~/.zshrc.local override (last)
|-- dot_config/agent/AGENTS.md   # shared agent rules (single source; tools symlink here)
|-- dot_config/{mise,just}/      # tool versions and global just recipes
|-- dot_homebrew/Brewfile        # curated brew/cask/mas packages (refresh via `brewfile-backup` skill)
|-- dot_*/                       # rendered home-directory dotfiles and private app configs
|-- Library/Application Support/ # app config copied into macOS support paths
|-- workspaces/                  # per-workspace AGENTS.md (+ CLAUDE.md symlink)
|-- .agents/, .claude/skills/    # repo-local skills (pnpm dlx skills project scope)
`-- .system-fonts/               # tracked binary font assets; installed by script
```

## SCRIPTS

Run in name order after files are applied. Each re-runs only when its rendered content changes.

| Script | Trigger | Does |
|--------|---------|------|
| `10-brew-bundle` | Brewfile hash | `brew bundle install --no-upgrade` (fails if Homebrew is missing) |
| `20-mise-install` | `dot_config/mise/config.toml` hash | `mise install --yes` |
| `30-install-fonts` | `.system-fonts` file list | copies missing fonts to `~/Library/Fonts` (`cp -n`) |
| `40-install-agent-skills` | `.chezmoidata/skills.yaml` | `pnpm dlx skills@<skills_cli_version> add -g` per source |

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Shell aliases/env/PATH | `.chezmoidata/shell.yaml` | Source of template data for zsh files. |
| zsh startup behavior | `dot_zprofile.tmpl`, `dot_zshrc.tmpl` | mise: shims in zprofile, full activate via zplug `plugins/mise` in zshrc. `typeset -U path` dedupes PATH. |
| Tool versions | `dot_config/mise/config.toml` | Languages, package managers, CLIs, agent CLIs, MCP CLIs. |
| Packages | `dot_homebrew/Brewfile` | Curated (no library deps). Refresh with the repo-local `brewfile-backup` skill, not a raw `brew bundle dump`. |
| Global recipes | `dot_config/just/justfile` | Utility/macOS admin tasks, not test/lint. |
| Git defaults/ignore | `dot_gitconfig`, `dot_gitignore` | `main`, signed commits/tags, `gh` credential helper (resolved from PATH), global agent-dir ignores. |
| Claude Code settings | `.chezmoidata/claude.yaml`, `dot_claude/modify_settings.json` | modify-template overwrites only top-level keys listed in `claude_settings`; Orca-owned `hooks`/`statusLine` and other keys are preserved. After `/plugin` installs, add the plugin to `claude_settings.enabledPlugins` (`re-add` does not work). |
| MCP servers | `.chezmoidata/mcp.yaml`, `.chezmoitemplates/mcp-servers.json` | `mcp_servers` go to both tools (`modify_private_dot_claude.json` sets only `mcpServers` in `~/.claude.json`); `codex_mcp_servers` are Codex-only. Claude gets context7 from its plugin. |
| Codex config | `dot_codex/modify_private_config.toml`, `dot_codex/rules/claude.rules.tmpl` | modify-template sets only `mcp_servers` and `sandbox_workspace_write.writable_roots` (mirrors Claude `additionalDirectories`); other keys stay Codex-owned. Exec rules are generated from Claude `permissions` (`Bash(...)` allow/ask/deny → allow/prompt/forbidden). |
| Agent persona/rules (all tools) | `dot_config/agent/AGENTS.md` | Single source for Claude Code and Codex; both tool paths are symlinks to it. Do not repurpose as repo docs. |
| Agent skills | `.chezmoidata/skills.yaml` | External skill deps installed with `--agent universal` into `~/.agents/skills` (read directly by Codex, Cursor, Gemini CLI, etc.); `claude-code` is added only to get `~/.claude/skills` symlinks. Skills shipped as Claude plugins omit `claude-code` from `agents` and are enabled in `.chezmoidata/claude.yaml` instead. |
| Repo-local skills | `.agents/skills/`, `skills-lock.json` | Project-scope `pnpm dlx skills add` (e.g. `better-chezmoi`) plus hand-written `brewfile-backup` (not in the lock); `.claude/skills/*` are symlinks. Restore with `pnpm dlx skills experimental_install`. |
| Private app configs | `dot_omlx/`, `dot_config/*private*` | Treat as sensitive even if tracked. |
| Fonts | `.system-fonts/` | Binary assets; avoid text search/line-count assumptions. |

## CONVENTIONS

- Edit chezmoi source names (`dot_zshrc.tmpl`, `dot_config/...`), not rendered home paths.
- `.chezmoiignore` excludes `*.local`; use that suffix for machine-local files (`~/.zshrc.local`, `~/.ssh/config.local`, `dot_config/dbhub/config.local.toml`). Exception: `~/.ssh/config.local` is un-ignored and seeded once by `dot_ssh/create_private_config.local`.
- zsh templates use chezmoi Go-template ranges over `.environment`, `.paths`, `.aliases`, `.ghostty_aliases`, and `.zplug_plugins`.
- No CI/test/lint pipeline; verify with `chezmoi diff`, `chezmoi execute-template`, `bash -n`/`zsh -n`, and targeted CLI runs.
- Tool-side rule paths are chezmoi `symlink_*` sources; edit the real file under `dot_config/agent/` only.
- Skills are not vendored. Add/remove them in `.chezmoidata/skills.yaml`; prefer a Claude plugin over linking the skill to `claude-code` when one exists.
- App-owned configs that apps rewrite constantly (CodexBar, OrbStack, Docker `config.json`; Codex `config.toml`/`~/.claude.json` only partially via modify-templates) are intentionally not managed.

## ANTI-PATTERNS (THIS PROJECT)

- Do not paste private tokens/keys from tracked private config files into reports or generated docs; the repo is public.
- Do not rewrite `dot_config/agent/AGENTS.md` into generic project docs; it changes the global behavior of both agent CLIs after chezmoi apply.
- Do not run an unscoped `chezmoi apply` casually; check `chezmoi status`/`chezmoi diff` and apply named targets.
- Do not treat font files as text; grep/line-count output on `.ttf` is noise.

## UNIQUE STYLES

- Korean response/persona rules in `dot_config/agent/AGENTS.md` intentionally address the user as `은솔` and the assistant as `이로하`.
- Shell setup centers on mise, Homebrew, zplug, starship, Bun/PNPM, Android SDK paths, and 1Password SSH agent.

## COMMANDS

```bash
chezmoi status
chezmoi diff --exclude=scripts
chezmoi apply --dry-run --verbose
just --justfile dot_config/just/justfile --list
pnpm dlx skills list -g
```

## NOTES

- `dot_omlx/settings.json` holds a local-only omlx key in plaintext by choice; summarize presence, not values.

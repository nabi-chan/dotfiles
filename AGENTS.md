# PROJECT KNOWLEDGE BASE

**Generated:** 2026-06-29 16:56:01 KST
**Commit:** 1ee78d2
**Branch:** main

## OVERVIEW

chezmoi source repo for macOS-oriented dotfiles. Core stack is chezmoi templates, zsh/mise/just configs, opencode customization, local app configs, and checked-in font assets.

## STRUCTURE

```text
./
|-- .chezmoidata/shell.yaml     # zsh aliases, PATH entries, zplug plugin data
|-- .chezmoidata/skills.yaml    # global agent skill deps (installed via npx skills)
|-- run_onchange_after_install-agent-skills.sh.tmpl # runs npx skills add -g per source
|-- dot_zprofile.tmpl           # mise + Homebrew bootstrap, environment exports
|-- dot_zshrc.tmpl              # zplug, PATH, aliases, Warp hook
|-- dot_config/agent/           # shared agent rules (single source; other tools symlink here)
|-- dot_config/opencode/        # opencode runtime config; AGENTS.md is a symlink
|-- dot_config/{mise,just}/     # tool versions and global just recipes
|-- dot_*/                      # rendered home-directory dotfiles and private app configs
|-- Library/Application Support/ # app config copied into macOS support paths
`-- .system-fonts/              # tracked binary font assets; not code
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Shell aliases/env/PATH | `.chezmoidata/shell.yaml` | Source of template data for zsh files. |
| zsh startup behavior | `dot_zprofile.tmpl`, `dot_zshrc.tmpl` | Go-template syntax; keep `.chezmoidata` keys aligned. |
| Tool versions | `dot_config/mise/config.toml` | Includes `chezmoi`, `opencode`, `just`, `ast-grep`, MCP CLIs. |
| Global recipes | `dot_config/just/justfile` | `todo` assumes `rg`; this environment may not have it active. |
| Git defaults/ignore | `dot_gitconfig`, `dot_gitignore` | `main`, signed commits/tags, global ignore/agent temp exclusions. |
| opencode runtime config | `dot_config/opencode/opencode.jsonc` | MCPs, permissions, plugin list, instruction paths. |
| opencode agent models | `dot_config/opencode/oh-my-openagent.json` | Agent/category model routing. |
| Agent persona/rules (all tools) | `dot_config/agent/AGENTS.md` | Single source for Claude Code, Codex, opencode; the three tool paths are symlinks to it. Do not repurpose as repo docs. |
| Agent skills | `.chezmoidata/skills.yaml` | External skill deps; the `run_onchange_after_` script installs them with `npx skills add -g` into `~/.agents/skills` and links per agent. Skills shipped as Claude plugins omit `claude-code` from `agents` and are enabled in `dot_claude/settings.json` instead. |
| Repo-local skills | `.agents/skills/`, `skills-lock.json` | Project-scope `npx skills add` (e.g. `better-chezmoi`); `.claude/skills/*` are symlinks. Restore with `npx skills experimental_install`. `skills-lock.json` is in `.chezmoiignore`. |
| Private app configs | `dot_omlx/`, `dot_docker/`, `dot_orbstack/`, `dot_config/*private*` | Treat as sensitive even if tracked. |
| Fonts | `.system-fonts/` | Binary assets; avoid text search/line-count assumptions. |

## CONVENTIONS

- Edit chezmoi source names (`dot_zshrc.tmpl`, `dot_config/...`), not rendered home paths.
- `.chezmoiignore` excludes `*.local`; use that suffix for machine-local files.
- zsh templates use chezmoi Go-template ranges over `.environment`, `.paths`, `.aliases`, and `.zplug_plugins`.
- No CI/test/lint pipeline was found; verification is mostly `chezmoi diff`, targeted CLI runs, and manual review.
- opencode config is JSONC with trailing commas; preserve comments/trailing-comma style.
- `dot_config/agent/AGENTS.md` is an installed global instruction file shared by all three agent CLIs, not a normal directory knowledge base.
- Tool-side rule paths are chezmoi `symlink_*` sources; edit the real file under `dot_config/agent/` only.
- Skills are not vendored. Add/remove them in `.chezmoidata/skills.yaml`; prefer a Claude plugin over linking the skill to `claude-code` when one exists.

## ANTI-PATTERNS (THIS PROJECT)

- Do not paste private tokens/keys from tracked private config files into reports or generated docs.
- Do not rewrite `dot_config/agent/AGENTS.md` into generic project docs; it changes the global behavior of all three agent CLIs after chezmoi apply.
- Do not run `chezmoi apply` casually; prefer `chezmoi diff` or dry-run first.
- Do not treat font files as text; grep/line-count output on `.ttf` is noise.
- Do not assume `rg` is available unless mise shims are active; fallback to `git grep`/`git ls-files` worked during generation.

## UNIQUE STYLES

- Korean response/persona rules live in opencode AGENTS and intentionally address the user as `은솔` and the assistant as `이로하`.
- Shell setup centers on mise, Homebrew, zplug, starship, Bun/PNPM, Android SDK paths, and 1Password SSH agent.

## COMMANDS

```bash
chezmoi diff
chezmoi apply --dry-run
just --justfile dot_config/just/justfile --list
npx skills list -g
```

## NOTES

- Current working tree had pre-existing untracked `.zed/` during generation; leave it alone unless the user asks.
- `dot_config/just/justfile` contains utility/macOS admin tasks, not test/lint tasks.
- `dot_omlx/settings.json` and private config paths may contain live local secrets; summarize presence, not values.

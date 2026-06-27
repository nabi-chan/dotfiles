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
|-- dot_zprofile.tmpl           # mise + Homebrew bootstrap, environment exports
|-- dot_zshrc.tmpl              # zplug, PATH, aliases, Warp hook
|-- dot_config/opencode/        # opencode config, global AGENTS.md, custom skills
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
| opencode persona/rules | `dot_config/opencode/AGENTS.md` | This becomes `~/.config/opencode/AGENTS.md`; do not repurpose as repo docs. |
| Custom skills | `dot_config/opencode/skills/` | Each skill owns `SKILL.md` plus optional data/scripts. |
| UI/UX skill engine | `dot_config/opencode/skills/ui-ux-pro-max/` | See child `AGENTS.md`. |
| Private app configs | `dot_omlx/`, `dot_docker/`, `dot_orbstack/`, `dot_config/*private*` | Treat as sensitive even if tracked. |
| Fonts | `.system-fonts/` | Binary assets; avoid text search/line-count assumptions. |

## CODE MAP

LSP was inactive and `codegraph_*` tools were unavailable during generation; reference counts are unmeasured. Python symbols below are from AST inspection.

| Symbol | Type | Location | Refs | Role |
|--------|------|----------|------|------|
| `BM25` | class | `dot_config/opencode/skills/ui-ux-pro-max/scripts/core.py` | n/a | Tokenize, index, score CSV search corpus. |
| `CSV_CONFIG` / `STACK_CONFIG` | constants | `dot_config/opencode/skills/ui-ux-pro-max/scripts/core.py` | n/a | Domain-to-CSV routing and output columns. |
| `search()` | function | `dot_config/opencode/skills/ui-ux-pro-max/scripts/core.py` | n/a | Domain search entry point. |
| `search_stack()` | function | `dot_config/opencode/skills/ui-ux-pro-max/scripts/core.py` | n/a | Stack-specific guideline search. |
| `DesignSystemGenerator` | class | `dot_config/opencode/skills/ui-ux-pro-max/scripts/design_system.py` | n/a | Aggregates product/style/color/landing/typography guidance. |
| `persist_design_system()` | function | `dot_config/opencode/skills/ui-ux-pro-max/scripts/design_system.py` | n/a | Writes master/page override design-system docs. |
| `format_output()` | function | `dot_config/opencode/skills/ui-ux-pro-max/scripts/search.py` | n/a | CLI output formatter. |
| `rebuild_colors()` / `rebuild_ui_reasoning()` | functions | `dot_config/opencode/skills/ui-ux-pro-max/data/_sync_all.py` | n/a | Regenerate derived CSV rows from `products.csv`. |

## CONVENTIONS

- Edit chezmoi source names (`dot_zshrc.tmpl`, `dot_config/...`), not rendered home paths.
- `.chezmoiignore` excludes `*.local`; use that suffix for machine-local files.
- zsh templates use chezmoi Go-template ranges over `.environment`, `.paths`, `.aliases`, and `.zplug_plugins`.
- No CI/test/lint pipeline was found; verification is mostly `chezmoi diff`, targeted CLI runs, and manual review.
- opencode config is JSONC with trailing commas; preserve comments/trailing-comma style.
- `dot_config/opencode/AGENTS.md` is an installed global instruction file, not a normal directory knowledge base.
- `ui-ux-pro-max` keeps large CSV knowledge bases plus Python scripts; data changes can affect search/generation behavior.

## ANTI-PATTERNS (THIS PROJECT)

- Do not paste private tokens/keys from tracked private config files into reports or generated docs.
- Do not rewrite `dot_config/opencode/AGENTS.md` into generic project docs; it changes the user's global opencode behavior after chezmoi apply.
- Do not run `chezmoi apply` casually; prefer `chezmoi diff` or dry-run first.
- Do not treat font files as text; grep/line-count output on `.ttf` is noise.
- Do not assume `rg` is available unless mise shims are active; fallback to `git grep`/`git ls-files` worked during generation.

## UNIQUE STYLES

- Korean response/persona rules live in opencode AGENTS and intentionally address the user as `은솔` and the assistant as `이로하`.
- Shell setup centers on mise, Homebrew, zplug, starship, Bun/PNPM, Android SDK paths, and 1Password SSH agent.
- Custom opencode skills are first-class assets; several are landing-page/design-engine prompt packs, while `ui-ux-pro-max` is data/script backed.

## COMMANDS

```bash
chezmoi diff
chezmoi apply --dry-run
just --justfile dot_config/just/justfile --list
python3 dot_config/opencode/skills/ui-ux-pro-max/scripts/search.py "saas dashboard" --domain product --json
python3 dot_config/opencode/skills/ui-ux-pro-max/data/_sync_all.py
```

## NOTES

- Current working tree had pre-existing untracked `.zed/` during generation; leave it alone unless the user asks.
- `dot_config/just/justfile` contains utility/macOS admin tasks, not test/lint tasks.
- `dot_omlx/settings.json` and private config paths may contain live local secrets; summarize presence, not values.
- Use `dot_config/opencode/skills/ui-ux-pro-max/AGENTS.md` for skill-engine-specific guidance instead of bloating this root file.

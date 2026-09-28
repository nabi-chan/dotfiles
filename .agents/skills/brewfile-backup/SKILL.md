---
name: brewfile-backup
description: Use when the user asks to back up, dump, refresh, or sync the Homebrew Brewfile (dot_homebrew/Brewfile) in this chezmoi repo from the currently installed packages.
---

# Brewfile backup

`dot_homebrew/Brewfile` is a curated list: only packages the user installs on purpose, grouped by section. `brew bundle dump` also emits library dependencies, so never commit a raw dump.

## Steps

1. Dump the current state to a scratch file (stderr carries noisy tap warnings):

   ```sh
   dump=$(mktemp)
   brew bundle dump --force --no-describe --file="$dump" 2>/dev/null
   ```

2. Collect the facts used for filtering:

   ```sh
   brew leaves --installed-on-request 2>/dev/null   # top-level formulae
   ```

3. Build the new Brewfile from the dump:
   - `tap`, `cask`, `mas`, `vscode`, `npm` lines: take the dump as-is (it is the ground truth for what is installed).
   - `brew` lines: keep a formula when it is already in the current Brewfile, or when it is a leaf that the user runs directly (CLI/app, e.g. `ffmpeg`, `sshuttle`).
   - Drop formulae that are only libraries or build dependencies of other formulae (e.g. `openssl@3`, `libpng`, `icu4c@*`, `re2c`, `bison`, `zlib`), even if `brew leaves` lists them.
   - When unsure whether a new leaf is a library or a tool, ask the user instead of guessing.

4. Write it in the existing format: sections in this order, one blank line between sections, each with its header comment, entries in dump order. Omit empty sections.

   ```
   # Homebrew tap
   # Homebrew Formula
   # Homebrew Cask
   # Mac App Store
   # VSCode
   # npm
   ```

5. Show `git diff dot_homebrew/Brewfile` and report what was added, removed (no longer installed), and dropped as dependencies.

## Notes

- Changing the Brewfile re-triggers `.chezmoiscripts/run_onchange_after_10-brew-bundle.sh.tmpl` on the next `chezmoi apply` (`brew bundle install --no-upgrade`).
- Do not commit; the user commits separately.

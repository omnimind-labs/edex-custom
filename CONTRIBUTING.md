# Contributing to eDEX Custom

## Prerequisites
- Rust 1.95+ (`rustup update stable`)
- Node.js LTS + pnpm 11 (`npm i -g pnpm@11`)
- **Linux only:** `sudo apt-get install -y libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf`
- **Windows only:** Visual Studio Build Tools 2022 with "Desktop development with C++" workload

## Dev Setup
```bash
pnpm install
pnpm tauri dev
```

## Adding a Theme
1. Add a `const MY_THEME: Style = { ... }` in `src/lib/themes/styles.ts`
2. Add `MY_THEME = 'MY_THEME'` to the `Theme` enum in the same file
3. Add `case Theme.MY_THEME: return MY_THEME;` to the `selectStyle` switch
4. Add an `html[data-theme="my_theme"] { ... }` CSS vars block to `src/index.css`
   - Note: the attribute value is the enum value lowercased with underscores kept as-is
5. The theme picker auto-discovers all `Theme` enum values — no picker changes needed

## Keyboard Shortcuts
| Shortcut | Action |
|---|---|
| `Ctrl+Tab` | Next terminal tab |
| `Ctrl+Shift+Tab` | Previous terminal tab |

## Release
Push a `v*` tag — GitHub Actions builds Windows, Linux, and macOS automatically and creates a draft release.
```bash
git tag v1.x.x && git push origin --tags
```

## Reporting Issues
- Bugs: [GitHub Issues](../../issues)
- Security vulnerabilities: [GitHub Security Advisories](../../security/advisories/new)

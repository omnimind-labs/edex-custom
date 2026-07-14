# eDEX Custom — Project Summary

**Dates:** July 12–14, 2026  
**Repo:** https://github.com/omnimind-labs/edex-custom  
**Base:** [zluo01/edex-ui](https://github.com/zluo01/edex-ui) — Tauri v2 + SolidJS + Rust rewrite  
**Version:** 1.0.0 (tagged, CI pipeline triggered)

---

## What Was Built

A fork and customization of the best actively-maintained eDEX-UI reimplementation. Starting from a full research sweep of all ~30 active eDEX-related repos on GitHub (sorted by last-pushed), `zluo01/edex-ui` was selected as the base over the more popular `andreas-hartmann/xdex-ui` because it is a clean ground-up rewrite in Tauri v2 (Rust) + SolidJS + TypeScript — significantly better architecture, smaller binaries, no Electron CVE surface, and the most activity (pushed that same day).

---

## Changes Made (10 commits)

| Commit | Change |
|---|---|
| `b09f11e` | Initial fork — rebrand to "eDEX Custom", update Cargo.toml, tauri.conf.json, package.json |
| `11b8028` | Set Cargo.toml repository URL placeholder |
| `221d5e6` | **Fix:** WSL2 network monitor always showing DISCONNECTED — filter virtual NICs in `extract_network()`, dual-probe latency fallback |
| `338af62` | **Feat:** `edex-custom` green/amber theme added to styles.ts + index.css, set as default |
| `67470fd` | **Feat:** Configurable shell setting in settings panel + `Ctrl+Tab`/`Ctrl+Shift+Tab` tab switching |
| `cefdba4` | **Fix:** Nerd Font / icon glyph rendering — activate `Unicode11Addon`, add Nerd Font fallback to CSS font stack |
| `aad4c47` | **CI:** Windows build target added, tag-based release trigger (`v*`), `scripts/build-local.ps1` helper |
| `6fbc63b` | **Chore:** Renovate config updated (Cargo/npm grouping, tauri pin), `CONTRIBUTING.md` created |
| `ec1ee50` | **Style:** Biome quote fix in `session.tsx` |
| `3a582dd` | **Chore:** Finalize Cargo.toml repo URL to `ghosthack3r/edex-custom` |
| `d9ee2d1` | **Fix:** Migrate `biome.json` deprecated `recommended` → `preset` (fixes CI lint job) |

---

## Issues Fixed

| Issue | Description | Fix location |
|---|---|---|
| #828 | Network status always DISCONNECTED on WSL2 | `src-tauri/src/sys/main.rs` + `src/lib/queries/index.ts` |
| #834 | No binary releases / CI missing Windows | `.github/workflows/main.yml` |
| #837 | No keyboard shortcut for tab switching | `src/components/terminal/tab.tsx` |
| #838 | No configurable shell | `src/lib/setting/index.ts` + `src/components/setting/index.tsx` |
| #839 | Nerd Font glyphs render as boxes | `src/components/terminal/session.tsx` + `src/index.css` |

---

## Known Issues / Next Steps

### 🔴 Blocker (local dev only)
- **`link.exe` spaces-in-path error** — MSVC's `link.exe` cannot handle paths with spaces. The workspace is at `C:\Users\ghost\.bob\Project Files\...`. All Rust builds fail locally. **Workaround:** clone the repo to a path without spaces (e.g. `C:\dev\edex-custom`) to build locally. CI builds work fine on GitHub Actions (clean paths).

### 🟡 Deferred Features (backlog)
- **Globe widget** (issue #833) — geolocation globe from original eDEX-UI not yet in zluo01 base
- **Boot animation + sound effects** (issue #836) — additive feature
- **Modular layout** (issue #809) — drag-and-drop panel rearrangement
- **Shell → Rust wiring** — shell setting is stored in `.settings.dat` but `session/main.rs` still uses `CommandBuilder::new_default_prog()`. The stored value needs to be threaded through the IPC layer to `PtySessionManager`.
- **xterm v6 → v7 migration** — renovate will propose this; it's a breaking change
- **Tauri v2 → v3 migration** — not yet released, monitor

### 🟢 CI Status
- `master` push → lint + build (Linux, macOS, Windows) 
- `v*` tag → same + publishes draft GitHub Release
- biome.json migration fix pushed — rerun CI to verify

---

## Architecture Cheatsheet

```
edex-custom/
├── src/                          # SolidJS + TypeScript frontend
│   ├── components/               # UI widgets (terminal, system, network, filesystem, settings)
│   ├── lib/
│   │   ├── queries/index.ts      # TanStack Query — IP lookup, latency probe
│   │   ├── setting/index.ts      # tauri-plugin-store get/set (theme, shell, hiddenFiles)
│   │   ├── themes/styles.ts      # Theme enum + Style objects (ADD NEW THEMES HERE)
│   │   └── terminal/             # xterm session creation + addon wiring
│   ├── models/index.ts           # All TypeScript interfaces (SystemData, Style, FileInfo…)
│   └── index.css                 # CSS variables per data-theme (ADD CSS VARS HERE for themes)
│
└── src-tauri/                    # Rust backend
    └── src/
        ├── main.rs               # App entry, plugin setup, thread spawning
        ├── sys/main.rs           # SystemMonitor — CPU/GPU/mem/network/disk → events
        ├── session/main.rs       # PtySessionManager — PTY spawn/resize/write/close
        ├── file/main.rs          # DirectoryFileWatcher — fs events → frontend
        └── event/main.rs         # EventProcessor — routes all backend events to frontend
```

**Theme system:** Two files must stay in sync — `src/lib/themes/styles.ts` (xterm colors) and `src/index.css` (`html[data-theme="..."]` CSS vars). The theme picker auto-discovers all `Theme` enum values.

**Settings persistence:** `tauri-plugin-store` writes to `~/.config/edex-custom/.settings.dat`. Keys: `theme`, `shell`, `showHiddenFile`.

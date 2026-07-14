# eDEX Custom — Codex Handoff Context

> This file is the authoritative context document for any agent (Codex, Claude, GPT, etc.) picking up development. Read it fully before touching any code.

---

## Project Identity

| Field | Value |
|---|---|
| **Name** | eDEX Custom |
| **Repo** | https://github.com/omnimind-labs/edex-custom |
| **Base fork** | https://github.com/zluo01/edex-ui (Tauri v2 rewrite, NOT the original GitSquared/edex-ui) |
| **Original** | https://github.com/GitSquared/edex-ui (archived 2021, do not use as reference for code) |
| **Version** | 1.0.0 |
| **License** | GPL-3.0 |

---

## Tech Stack — Exact Versions

### Frontend
| Package | Version | Purpose |
|---|---|---|
| `solid-js` | 1.9.14 | Reactive UI framework |
| `@xterm/xterm` | 6.0.0 | Terminal emulator widget |
| `@xterm/addon-fit` | 0.11.0 | Auto-resize terminal to container |
| `@xterm/addon-unicode11` | 0.9.0 | Nerd Font / Unicode 11 glyph support ✅ activated |
| `@xterm/addon-webgl` | 0.19.0 | GPU-accelerated rendering |
| `@xterm/addon-clipboard` | 0.2.0 | Clipboard integration |
| `@tauri-apps/api` | 2.11.1 | Tauri IPC bridge |
| `@tauri-apps/plugin-store` | 2.4.3 | Persistent settings (`.settings.dat`) |
| `@tanstack/solid-query` | 5.101.2 | Data fetching / caching |
| `augmented-ui` | 2.0.0 | Sci-fi CSS border/clip decorations |
| `tailwindcss` | 4.3.2 | Utility CSS (v4 — no config file, all in CSS) |
| `typescript` | 6.0.3 | Type checking |
| `vite` | 8.1.3 | Dev server + bundler |
| `biome` | 2.5.2 | Linter + formatter (replaces ESLint + Prettier) |

### Backend (Rust)
| Crate | Version | Purpose |
|---|---|---|
| `tauri` | 2.11.x | App framework |
| `portable-pty` | (via tauri) | PTY sessions |
| `sysinfo` | 0.39.x | CPU/GPU/memory/network/disk |
| `notify` | (via tauri) | File system watcher |
| `tauri-plugin-store` | 2.x | Settings persistence |
| `tauri-plugin-log` | 2.x | Structured logging |
| `tauri-plugin-os` | 2.x | OS detection |

### Tooling
| Tool | Version |
|---|---|
| pnpm | 11 |
| Node.js | LTS (20+) |
| Rust | 1.95+ (stable) |
| tauri-cli | 2.11.4 |

---

## Repository Structure

```
edex-custom/
├── .github/
│   └── workflows/main.yml        # CI: lint → build (Linux/macOS/Windows) → release on v* tag
├── .husky/
│   ├── pre-commit                 # runs: pnpm lint (biome check --write + cargo fmt + cargo clippy)
│   └── pre-push                   # runs: pnpm lint (same) — BROKEN locally due to spaces in path
├── biome.json                     # Linter/formatter config (migrated to preset:recommended in d9ee2d1)
├── CHANGELOG.md                   # Release history
├── CONTRIBUTING.md                # Dev setup + theme guide
├── CONTEXT.md                     # ← this file
├── index.html                     # Vite entry point
├── package.json                   # pnpm workspace root (name: edex-custom)
├── pnpm-lock.yaml                 # Lockfile — do not edit manually
├── pnpm-workspace.yaml
├── renovate.json                  # Auto-dep-update config (weekly, automerge JS+Rust, tauri pinned)
├── scripts/
│   └── build-local.ps1            # Windows local build helper
├── screenshots/
├── src/                           # ← SolidJS frontend
│   ├── App.tsx                    # Root component — mounts all panels
│   ├── main.tsx                   # Vite/SolidJS entry
│   ├── index.css                  # Global CSS + Tailwind + per-theme CSS vars
│   ├── vite-env.d.ts
│   ├── models/index.ts            # ALL TypeScript interfaces (single source of truth)
│   ├── components/
│   │   ├── banner/                # Top header bar
│   │   ├── dashboard/             # CPU/GPU usage table
│   │   ├── divider/               # Layout divider
│   │   ├── filesystem/            # File browser (file, icon, tile views)
│   │   ├── network/               # Network status, traffic, disk usage
│   │   ├── setting/
│   │   │   ├── index.tsx          # Settings modal — shell input, theme picker, hidden files toggle
│   │   │   ├── hidden.tsx         # Show/hide dotfiles toggle
│   │   │   └── theme.tsx          # Theme selector (auto-discovers Theme enum values)
│   │   ├── system/                # Clock, hardware info, memory, process list, sysinfo
│   │   └── terminal/
│   │       ├── index.tsx          # Terminal panel mount point
│   │       ├── session.tsx        # xterm instance setup, addon loading, resize handling
│   │       └── tab.tsx            # Tab bar + Ctrl+Tab / Ctrl+Shift+Tab switching
│   └── lib/
│       ├── log/index.ts           # traceLog() / errorLog() wrappers → tauri-plugin-log
│       ├── os/index.ts            # Tauri commands for PTY ops (initializeSession, writeToSession…)
│       ├── queries/index.ts       # TanStack Query — IP geolocation + latency dual-probe
│       ├── setting/index.ts       # Store get/set: theme, shell, showHiddenFile
│       ├── system/index.tsx       # SolidJS context for SystemData (CPU/GPU/mem/processes)
│       ├── terminal/
│       │   ├── create.ts          # createTerminal() — xterm init + all addon setup
│       │   ├── index.ts           # Addons type export
│       │   └── provider.tsx       # Terminal context provider
│       ├── themes/
│       │   ├── index.tsx          # useTheme() hook
│       │   ├── provider.tsx       # Theme context + persistence (reads/writes store)
│       │   ├── styles.ts          # Theme enum + Style objects ← ADD NEW THEMES HERE
│       │   └── terminal.ts        # generateTerminalTheme() — maps Style → xterm ITheme
│       └── utils/index.ts         # cn() (Tailwind class merge), closeModal()
└── src-tauri/                     # ← Rust backend
    ├── build.rs
    ├── capabilities/default.json  # Tauri permissions (http:default added for latency probes)
    ├── Cargo.toml                 # name: edex-custom, version: 1.0.0, repo: ghosthack3r/edex-custom
    ├── Cargo.lock
    ├── tauri.conf.json            # productName: eDEX Custom, identifier: com.edex-custom.app
    ├── icons/
    └── src/
        ├── main.rs                # Entry: plugin setup, spawn SystemMonitor thread, start app
        ├── event/
        │   └── main.rs            # EventProcessor — async event bus routing backend → frontend
        ├── file/
        │   └── main.rs            # DirectoryFileWatcher — fs notify → frontend file events
        ├── session/
        │   └── main.rs            # PtySessionManager — spawn/resize/write/close PTY sessions
        └── sys/
            └── main.rs            # SystemMonitor — polls sysinfo every N sec, emits events
                                   # extract_network() filters virtual NICs (WSL2 fix)
```

---

## Critical Patterns — Must Know Before Editing

### 1. Theme System (two files, always in sync)

**File 1:** `src/lib/themes/styles.ts`
```typescript
// Step A: add enum value
export enum Theme {
  TRON = 'TRON',
  EDEX_CUSTOM = 'EDEX_CUSTOM',   // ← our addition
  // ...
}

// Step B: add Style object
const EDEX_CUSTOM: Style = {
  colors: { main: 'rgb(0,255,128)', black: '#000000', grey: '#0d1f10', ... },
  terminal: { fontFamily: 'Fira Mono', cursorStyle: 'block', foreground: '#00ff80', ... },
};

// Step C: add case to selectStyle()
case Theme.EDEX_CUSTOM: return EDEX_CUSTOM;
```

**File 2:** `src/index.css` — inside `@layer base`:
```css
/* data-theme value = Theme enum value lowercased: EDEX_CUSTOM → edex_custom */
html[data-theme="edex_custom"] {
  --bg-main: 3 10 5;           /* RGB triplet, NO rgb() wrapper */
  --bg-secondary: 13 31 16;
  --bg-active: 0 255 128;
  --border-default: 0 255 128;
  --text-main: 0 255 128;
  --text-active: 3 10 5;
  --color-stroke: rgb(0, 255, 128);
  --color-shade: #0d1f10;
}
```

The **theme picker auto-discovers** all `Theme` enum values via `Object.values(Theme)` — no picker changes needed when adding themes.

### 2. Settings Persistence

`tauri-plugin-store` writes to `~/.config/edex-custom/.settings.dat` (platform-specific userData dir).

```typescript
// src/lib/setting/index.ts
import { load } from '@tauri-apps/plugin-store';

// Singleton store with defaults
const store = await load('.settings.dat', {
  defaults: { showHiddenFile: false, theme: Theme.EDEX_CUSTOM },
  autoSave: true,
});

// Exported getters/setters
export async function getTheme(): Promise<Theme> { ... }
export async function setTheme(theme: Theme) { ... }
export async function getShell(): Promise<string> { ... }   // ← our addition
export async function setShell(shell: string) { ... }       // ← our addition
```

**⚠️ Shell setting incomplete:** `getShell()`/`setShell()` are implemented in the frontend store, but `src-tauri/src/session/main.rs` still uses `CommandBuilder::new_default_prog()` — it does NOT yet read the stored shell value. This is the primary incomplete feature from v1.0.0.

### 3. Network Status

Two-layer fix applied for WSL2 (commit `221d5e6`):

**Rust side** (`src-tauri/src/sys/main.rs` ~line 403):
```rust
fn is_virtual(name: &str) -> bool {
    let n = name.to_lowercase();
    n == "lo" || n == "lo0"
        || n.starts_with("vethernet")   // WSL2 / Hyper-V
        || n.starts_with("docker")
        || n.starts_with("virbr")
        || n.starts_with("vmnet")
        || n.starts_with("veth")
}
```

**Frontend side** (`src/lib/queries/index.ts`):
```typescript
// Tries cloudflare-dns.com first, falls back to 1.1.1.1
const probes = [
  'https://cloudflare-dns.com/dns-query?name=example.com&type=A',
  'https://1.1.1.1/dns-query?name=example.com&type=A',
];
```

### 4. Terminal Session + Addons

Addons are loaded in `src/components/terminal/session.tsx` inside `onMount`, AFTER `initializeSession(id)`:

```typescript
// Order matters:
const terminal = createTerminal(terminalEl, theme());  // creates xterm instance
await initializeSession(id);                            // connects to Rust PTY

// Unicode11 (our addition, commit cefdba4):
const unicode11Addon = new Unicode11Addon();
terminal.term.loadAddon(unicode11Addon);
unicode11Addon.activate(terminal.term);
terminal.term.unicode.activeVersion = '11';

await resize(id, terminal.term, terminal.addons);
```

### 5. IPC Pattern (Rust → Frontend)

The Rust backend emits Tauri events. The frontend listens via `@tauri-apps/api/event`:

```typescript
// Frontend listener pattern (from session.tsx):
const unlisten = await listen<string>('terminal-output-${id}', (event) => {
  terminal.term.write(event.payload);
});
onCleanup(() => unlisten());
```

Rust emits via `app_handle.emit("event-name", payload)`.

### 6. Biome (Linter/Formatter)

Project uses **Biome 2.5.2** (not ESLint/Prettier). Config in `biome.json`.
- Quotes: **single quotes** for JS/TS strings
- Arrow functions: **no parens for single params** (`v =>` not `(v) =>`)
- Import order is enforced — imports are sorted automatically

Run: `pnpm exec biome check --write src/` to auto-fix before committing.

### 7. Husky Hooks

`.husky/pre-commit` and `.husky/pre-push` both run `pnpm lint` which includes:
1. `biome check --write .` — auto-fixes and then errors if unfixable issues remain
2. `cargo fmt` — Rust formatting
3. `cargo clippy -- -D warnings` — Rust linting

**⚠️ Local build blocker:** `cargo fmt` and `cargo clippy` both fail locally because MSVC's `link.exe` cannot handle the path `C:\Users\ghost\.bob\Project Files\edex-custom` (spaces in path). Use `git commit --no-verify` and `HUSKY=0 git push` locally. **This does not affect GitHub Actions CI** which runs in `/home/runner/work/...` (no spaces).

**Fix:** Clone to a path without spaces, e.g. `C:\dev\edex-custom`.

---

## CI / CD

**File:** `.github/workflows/main.yml`

| Trigger | Jobs |
|---|---|
| Push to `master`/`main` or PR | `lint` → `build-tauri` (Linux, macOS arm64, Windows) |
| Push `v*` tag | `lint` → `build-tauri` → `publish-tauri` (creates draft GitHub Release) |
| `workflow_dispatch` | Same as push to master |

**Current CI status:** `d9ee2d1` pushed biome.json migration fix — CI should pass on next run.

**To release:** `git tag v1.x.x && HUSKY=0 git push origin --tags`

---

## Incomplete / TODO (Prioritized for Codex)

### P0 — Wire shell setting to Rust PTY (already half-done)

The frontend stores the shell path. The Rust session manager needs to read it.

**What to do:**
1. In `src-tauri/src/session/main.rs`, add a Tauri command `get_shell_setting` or pass shell as a parameter to the PTY spawn IPC call
2. Read from `tauri-plugin-store` in Rust OR pass shell string as argument from frontend when spawning a new session
3. Change `CommandBuilder::new_default_prog()` to `CommandBuilder::new(shell_path)` when shell is set

**Files:** `src-tauri/src/session/main.rs`, `src/lib/os/index.ts` (IPC call), `src/components/terminal/tab.tsx` (new tab spawn)

### P1 — Fix local Rust build (spaces-in-path)

Move the project to `C:\dev\edex-custom` or equivalent. Update `Cargo.toml` repository URL if needed.

### P2 — Globe widget (issue #833)

The original eDEX-UI had an Encom-style geolocation globe. The zluo01 base doesn't have one. Would require:
- A SolidJS component wrapping a WebGL globe library
- IP geolocation data already available via `src/lib/queries/index.ts` (`getIPInformation()`)

### P3 — Boot animation + sound effects (issue #836)

Additive feature — sci-fi boot sequence on startup.

### P4 — Modular layout (issue #809)

Drag-and-drop panel rearrangement. Large feature — would require layout state persistence in the store.

---

## Dev Setup (Quick Reference)

```bash
# Prerequisites: Rust 1.95+, Node LTS, pnpm 11
# IMPORTANT: clone to a path WITHOUT spaces on Windows

git clone https://github.com/omnimind-labs/edex-custom.git C:\dev\edex-custom
cd C:\dev\edex-custom

pnpm install
pnpm tauri dev       # starts dev server + Rust backend

# Before committing:
pnpm type-check      # TypeScript
pnpm exec biome check --write src/   # fix lint/format

# Release:
git tag v1.x.x
HUSKY=0 git push origin --tags
```

---

## Conversation History Note

This project was built in a single conversation session with IBM Bob (Claude-based agent). The conversation covered:
1. Research of all active eDEX-UI forks (GitHub API search)
2. Selection of `zluo01/edex-ui` over `andreas-hartmann/xdex-ui` based on architecture comparison
3. Plan writing (two full plans — first for xdex-ui, revised for zluo01)
4. Subagent-driven development execution (8 tasks, each with spec + quality review)
5. GitHub repo creation via `gh` CLI (`omnimind-labs` account)
6. Tag push + CI trigger

Plans are saved in `docs/superpowers/plans/` in the parent workspace.

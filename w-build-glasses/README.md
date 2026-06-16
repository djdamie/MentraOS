# W. Build — Glasses Project

This directory is **W. / ELYCIUM's working project root** inside this fork of MentraOS. Everything in `w-build-glasses/` is ours — the upstream MentraOS code lives in the rest of the tree (`cloud/`, `sdk/`, `mobile/`, `miniapps/`, etc.) and we leave it untouched so we can sync from upstream cleanly.

## Why this fork exists

Scott bought a pair of [Mentra Live smart glasses](https://mentraglass.com/live) on 29 May 2026. The strategic frame, set in [`Mentra Live — Smart Glasses Evaluation`](https://github.com/djdamie/w-project-template) in the Obsidian vault, is that glasses are a **second input layer** for the same site-AI back-end we're building for fixed Reolink cameras at W.'s construction sites. Same YOLOE detection, same W.OS agent mesh, same Slack / Monday outputs — different camera on a different head.

We forked MentraOS (rather than just installing the SDK) for three reasons:

1. **Full visibility into the OS.** When the SDK does something unexpected, we want to read the source.
2. **Track upstream changes.** MentraOS 3.0 lands summer 2026; we want to see what's coming.
3. **Optionality on contributing back.** If we build something useful (a construction-specific MiniApp template, for example), it's a small step to PR it upstream.

The fork is a long-term project home. The team works in `w-build-glasses/`. We don't edit the rest of the tree unless we mean to.

## What's in this directory

- **`CLAUDE.md`** — the project's standing instructions for Claude Code. Read first.
- **`BUILD_NOTES.md`** — single source for where-we-are / what's-left / next build. Updated every session that ships state.
- **`goals/`** — per-task rubrics that sessions hill-climb against. See `goals/README.md` for the pattern.
- **`docs/`** — architecture summary, current state audit, design specs and implementation plans under `docs/superpowers/`.

## Standard from the W. project template

This is laid out per [`w-project-template`](https://github.com/djdamie/w-project-template) — the reusable W. / ELYCIUM scaffold for any project that runs with Claude Code and a small team. Same shape every time: `CLAUDE.md` for standing context, `BUILD_NOTES.md` for running state, `goals/` for substantive build work.

## Working with the rest of the fork

The upstream MentraOS root has its own `CLAUDE.md` (`@AGENTS.md` import) — that's their playbook for working in this codebase. We've extended it to also `@w-build-glasses/CLAUDE.md` so a Claude Code session opened at the repo root gets both. A session opened *inside* `w-build-glasses/` only loads ours.

When you pull from upstream Mentra-Community/MentraOS, the diff should never touch `w-build-glasses/`. If it does, that's a flag to investigate.

# W. Build Glasses — Project Instructions for Claude Code

## What This Is

A working repo for building **W.-specific Mentra Live smart glasses apps** that feed into the W. Operating System. Part of the broader [W. site cameras strategy](https://github.com/djdamie/w-project-template) — fixed Reolink cameras + viACT pilot + Mentra glasses, all three input layers publishing into the same W.OS agent mesh.

The glasses are the **worker-facing input layer**. They give us camera footage and audio narration from a person inspecting / walking / verifying — the camera goes where the worker goes. Fixed cameras handle always-on; glasses handle intentional, targeted, expertise-augmented work (defect walkarounds, real-time subcontractor verification, on-demand expertise for junior staff).

**Not to be confused with:**
- **The upstream `MentraOS` codebase** in the rest of this tree. That's the OS itself; we're a fork. Our project files live in `w-build-glasses/` and don't touch upstream.
- **`MentraOS-Camera-Example-App`** — Mentra's official starter template (a separate repo). Useful reference; we read it but don't depend on it.
- **W.Home App** — a different product (concierge app for completed W. builds). Different stack, different rock.
- **W.OS the agent system** — the back-end this project publishes findings into. Lives in [`wos-codebase`](https://github.com/djdamie/wos-codebase).

## The Rock — What Done Looks Like

Q3 2026 (provisional, framing pending Scott confirmation):

> **W. Defect Walkaround v0 — Aug 30, 2026** — A working MentraOS app on Scott's Mentra Live glasses that lets the wearer trigger a defect capture via voice, takes a photo + records 10s of audio narration, runs the photo through YOLOE prompts (or Roboflow Inference), whispers the result to the wearer, and publishes a structured finding to the W.OS NATS event bus. Pilot on one PM (Mitch or Scott) for one week.

**Interim milestones:**

- **Week 1 (target: Jun 23, 2026):** Camera Example App running end-to-end on Scott's glasses. Photos capture, show on phone, dev loop is live. See `goals/0001-camera-example-running.goal.md`.
- **Week 2–3:** Custom W. v0 app — voice command triggers photo + audio, sends to a local webhook, structured payload saved. No AI yet.
- **Week 4–5:** Detection layer wired in — Roboflow Inference or YOLOE on a paired phone, audio response to wearer.
- **Week 6+:** W.OS bridge — findings publish to `wos.camera.glasses_agent` on NATS, W.OS agents create Monday records.

When in doubt about scope, ask: does this move us toward the Aug 30 defect walkaround v0? If neither yes nor "necessary plumbing for it", defer.

## Architecture & Current State — Read These First

For every meaningful change, the design docs are the source of truth:

- **`docs/ARCHITECTURE.md`** — Working summary of the three-layer architecture (glasses → inference → W.OS). Damo's distillation; defer to source-of-truth specs in `docs/superpowers/specs/` when there's any conflict.
- **`docs/CURRENT_STATE.md`** — Feature audit. What's working, what's scaffolded, what's mocked, what blocks production.
- **`docs/superpowers/specs/`** — Source-of-truth design specs as they're written. Verbatim — don't edit retroactively.

The original strategic frame lives in the Obsidian vault at `Projects/Australia - W. ELYCIUM/R&D/Mentra Live — Smart Glasses Evaluation.md`. That's the "why we picked Mentra" document; this CLAUDE.md is the "how we're building on it" document.

## Tech Stack (Current)

- **MentraOS Cloud SDK** — TypeScript SDK for Mentra Live glasses + paired phone, via the Mentra Relay Server. From the upstream repo we're forked from.
- **Bun** — package manager + runtime. Required by Mentra examples.
- **ngrok** — exposes the local dev server to the Mentra Relay Server. Static URL configured in `console.mentraglass.com`.
- **TypeScript strict.**

## Tech Stack (Target — Per Architecture Spec)

- **MentraOS Bluetooth SDK** — native (Android/iOS/React Native) once we want to ship a real W. app that runs without ngrok / Relay Server. Phase 2.
- **Inference layer:** Roboflow Inference on a paired phone (prototyping) → edge Jetson AGX Orin (production). Same hardware we're buying for the fixed-camera build, so the layer compounds.
- **W.OS bridge:** Python service consuming the glasses app's findings via REST webhook and publishing to NATS on `wos.camera.glasses_agent`. Ed owns; same pattern as the Finance Agent bridge.
- **MentraOS 3.0** — coming summer 2026. Apps run on the phone directly, no relay server. Watch for it; migrate when it's stable.

## Standing Rules

- **Agents draft, humans approve.** Glasses-driven actions never autonomously close defect records, schedule rectification, or contact subcontractors without a human in the loop. The audio whisper is informational, not authoritative.
- **Right model for the right task.** Claude for the bridge service reasoning. YOLOE / Roboflow models for vision. Gemini 2.5 Flash for harder VLM calls. No local models for tool-using agents (prompt injection risk).
- **Never commit secrets.** `.env`, MentraOS app secrets, ngrok auth tokens stay out of the repo. Roboflow API keys, OpenAI keys — server-side only before any deploy.
- **Dates absolute, currency explicit.** `Jun 16, 2026` in prose; `2026-06-16` in code/data. AUD/USD always specified.
- **Privacy is a hard constraint.** POV worker recording at luxury client homes needs a clear policy before any deployment to a site beyond Scott's own walking. Footage retention defaults to 14 days on-device, event clips only to cloud archive.
- **Don't touch the rest of the fork.** Our work lives in `w-build-glasses/`. The upstream MentraOS code (`cloud/`, `sdk/`, `mobile/`, etc.) is read-only for us — we sync from upstream, we don't drift.

## How goals work (the loop)

Substantial build work runs as **goal files**: `goals/<NNNN>-<name>.goal.md` is a rubric the implementing session hill-climbs against, not a wish list. Shape (see `goals/TEMPLATE.goal.md`): what already exists → read first → locked conventions → run order where **each item's verification is a gate** (loop until green before the next) → ⏸ pause points where a named human decides → checkable done criteria → a **Grader** (a fresh subagent that hasn't seen the build, told to *refute* each criterion against the diff) → distill what the work taught into `BUILD_NOTES.md` and write the next goal while context is hot. A goal file is the handoff unit between sessions and people — one session prepares it; a teammate or a Conductor worktree executes it.

This rides on the superpowers skills if they're installed: `test-driven-development` + `verification-before-completion` are the per-item gate; `requesting-code-review` run as a fresh subagent is the Grader; `executing-plans` runs the rubric; `brainstorming`/`writing-plans` precede it.

Current build goal: `goals/0001-camera-example-running.goal.md`.

## Working With This Codebase

**Repository structure (our part):**

- `w-build-glasses/CLAUDE.md` — this file. Standing instructions.
- `w-build-glasses/BUILD_NOTES.md` — running state. The first thing the next session reads after CLAUDE.md.
- `w-build-glasses/goals/` — per-task rubrics. `0001-...goal.md` is the first.
- `w-build-glasses/docs/ARCHITECTURE.md` — working architecture summary.
- `w-build-glasses/docs/CURRENT_STATE.md` — feature audit.
- `w-build-glasses/docs/superpowers/specs/` — source-of-truth design specs.
- `w-build-glasses/docs/superpowers/plans/` — implementation plans.
- `w-build-glasses/app/` (created when goal 0001 lands) — the actual TypeScript code for our W. glasses app, scaffolded from `MentraOS-Camera-Example-App`.

**Upstream MentraOS structure (read-only for us):**

- `cloud/`, `cloud-v2/` — the Mentra Relay Server and management cloud.
- `sdk/` — the TypeScript SDK we depend on.
- `mobile/` — the MentraOS mobile app (React Native).
- `miniapps/`, `local-miniapps/` — example MiniApps in their app store.
- `asg_client/` — Android Smart Glasses native client.
- `agents/` — Mentra's own AGENTS.md helpers.
- `AGENTS.md`, `CONTRIBUTING.md`, `glasses-compatibility.md` — Mentra's docs.

**Conventions:**

- All our code lives under `w-build-glasses/app/`. No exceptions. The rest of the tree is upstream Mentra.
- Bun (not npm or yarn). The upstream repo uses Bun; we match.
- TypeScript strict.
- When in doubt about the SDK shape, read `sdk/` in the upstream tree — that's the actual source of the thing we're calling.
- Phone-pair compute: the glasses themselves don't have AI inference. Heavy lifting goes to the paired phone or a Jetson on the same network. Design every feature with that in mind.

**Reference projects:** W.Home App (`/Users/damo/Documents/W_projects/w.home-prototype-main/`) for the CLAUDE.md + goals pattern. `wos-codebase` for the NATS event-bus shape our bridge service will publish to.

## Active Workstream (as of 2026-06-16)

> **Current build status lives in [`BUILD_NOTES.md`](BUILD_NOTES.md)** — the single source for where-we-are / what's-left / next build.

**Settled (don't relitigate):**

- Hardware = Mentra Live (Scott's pair, arrived ~mid-June 2026).
- SDK path = MentraOS Cloud SDK (TypeScript + Bun + ngrok + Relay Server) for Phase 1. Migrate to Bluetooth SDK when we ship a real app.
- Project home = this fork's `w-build-glasses/` directory.
- Camera Example App = the starter we follow. Not forked, just referenced.
- Inference happens off-glasses. Mentra Live has no AI chip; phone or Jetson does the work.
- First use case = defect walkaround. Other use cases (subcontractor verification, on-demand expertise) follow.
- Division of labour = Damo + Ed build; Scott is first user. Specialist contractor (per the [contractor brief](https://github.com/djdamie/w-project-template)) only if/when Phase 2 hits scale.

**Pending (blocks visible demo progression):**

- Mentra account + console.mentraglass.com app registration. Damo to set up, register the W. app, get the package name + ngrok URL wired.
- ngrok static URL — needs an account + the `ngrok config add-authtoken` step.
- Phone — Damo or Scott's. iOS 15.1+ or Android 12+. Pair to glasses.

**Parked until post-Goal-0001:**

- Voice activation pattern (what trigger word? "capture", "log", "snap"?)
- Audio response copy (tone, length, what to say when detection confidence is low)
- W.OS NATS subjects + payload schema for `wos.camera.glasses_agent` (Ed)
- Privacy policy for POV recording at client sites
- Bluetooth SDK migration plan
- MentraOS 3.0 evaluation when it ships

## Things to Defer

These are real and important, but none of them is what gets Goal 0001 to "Camera Example App running on Scott's glasses". Don't start them until 0001 is done:

- Native (Bluetooth) SDK migration
- MentraOS 3.0 evaluation
- VLM integration (Qwen2.5-VL, Gemini 2.5 Flash) — keep YOLOE / Roboflow as the v0 detection layer
- Production telemetry / observability
- Multi-user / multi-PM rollout (Scott is the only user until v0 lands)
- Custom MiniApp Store submission
- AR overlay / HUD work (Mentra Display hardware not shipping yet)

## Where Things Live

- **This repo:** `https://github.com/djdamie/MentraOS` (fork of Mentra-Community/MentraOS, working in `w-build-glasses/`)
- **Local checkout:** `/Users/damo/Documents/W_projects/MentraOS/`
- **Sister codebases:**
  - `wos-codebase` — W.Operating System (NATS event bus, agent platform). Glasses findings publish to `wos.camera.glasses_agent` on the bus.
  - `w-project-template` — the reusable W. project scaffold this repo is patterned on.
- **Mentra developer console:** `https://console.mentraglass.com` (register our app there; package name + public URL configured)
- **MentraOS docs:** `https://docs.mentraglass.com` — Quickstart, SDK reference, deployment guide.
- **MentraOS Discord:** `https://discord.gg/5ukNvkEAqT` — fastest place to get unstuck.
- **Reference: Camera Example App:** `https://github.com/Mentra-Community/MentraOS-Camera-Example-App` — read the source when our SDK calls misbehave.
- **Strategic frame (Obsidian vault):** `Projects/Australia - W. ELYCIUM/R&D/Mentra Live — Smart Glasses Evaluation.md`
- **Roboflow account** (for inference layer): TBD — first set up during goal 0003 / 0004.

## Update Discipline

Update `CLAUDE.md` (this file) when:
- The active rock or milestone changes
- A standing rule changes
- A foundational architectural decision is made (e.g., switching SDK path)

Update `BUILD_NOTES.md` every session that ships meaningful state. The "Active" header gets re-dated; the dated log is append-only.

Update `docs/ARCHITECTURE.md` when:
- An open decision closes
- A new architectural surface is committed (e.g., chosen inference platform, chosen W.OS event schema)
- The phase plan shifts

Update `docs/CURRENT_STATE.md` when:
- A feature moves between mocked / scaffolded / working / broken
- A new known gap is discovered
- A demo blocker is identified or resolved

Keep all four files in the same voice — direct, terse, present tense, no marketing.

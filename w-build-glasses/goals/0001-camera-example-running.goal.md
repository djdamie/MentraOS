# Goal: 0001 — Camera Example App running on Scott's Mentra Live glasses

**Created:** 2026-06-16
**Status:** ready to execute
**Author of this goal:** Damo
**Executor (when started):** Damo (with Scott as user for the device pairing + capture step)

## Why this goal exists

Scott has a pair of Mentra Live glasses in his hands. Before we build anything W.-specific, we need to confirm the dev loop works end-to-end: SDK setup, ngrok tunnel, Mentra console registration, phone pairing, glasses capturing a photo and showing it on the phone. **No code we write matters until this loop is live.** The Camera Example App from Mentra is the cheapest way to prove the loop.

Goal 0002 (the W. defect walkaround MVP) is blocked on this. Don't skip steps; the value here is in proving each wire.

## What already exists

- Scott's Mentra Live glasses (received ~mid-June 2026).
- This fork of MentraOS at `djdamie/MentraOS`, with our project scaffold in `w-build-glasses/`.
- `BUILD_NOTES.md` flags three blockers that must clear during this goal: Mentra console account, ngrok static URL, paired phone.

What does **not** exist yet:
- A `w-build-glasses/app/` directory (will be created from the Camera Example App template in Step 3).
- A registered W. app in `console.mentraglass.com`.
- An ngrok account and static domain.

## Read first (in this order)

The executing session must read these *before* starting:

1. **`w-build-glasses/CLAUDE.md`** — project standing instructions; specifically the Tech Stack and Standing Rules sections.
2. **`w-build-glasses/BUILD_NOTES.md`** — current blockers.
3. **MentraOS Quickstart docs** — https://docs.mentraglass.com/app-devs/getting-started/quickstart. The exact 5-step setup we're following.
4. **MentraOS-Camera-Example-App repo** — https://github.com/Mentra-Community/MentraOS-Camera-Example-App. Skim the README + the entry point to know what the example does.
5. **`AGENTS.md` at the upstream root** — Mentra's own playbook for working in this codebase. Useful general context for the SDK shape.

If the Quickstart docs have materially changed since this goal was written, **stop and surface that** — the steps below may need updating.

## Locked conventions

- **Use the Cloud SDK path (TypeScript + Bun + ngrok + Relay Server).** Not the native Bluetooth SDK. We trade native polish for setup speed. Migration to the Bluetooth SDK is a Phase 2 goal.
- **Code lives in `w-build-glasses/app/`.** Not at the repo root. Not anywhere else in the fork. The rest of the tree is upstream Mentra and we don't touch it.
- **Bun (not npm or yarn).** Matches the upstream repo and Mentra's docs.
- **Package name format:** `build.w.<short-app-name>`. For this goal: `build.w.camera-example`.
- **Secrets stay out of git.** `.env` is gitignored; ngrok auth tokens and MentraOS API keys never get committed.

## Run order

### Step 1 — Mentra developer console + app registration

**What:**
- Create or sign in to a MentraOS account at `console.mentraglass.com` using the same email as the phone app.
- Install the **MentraOS app** on a phone (iOS 15.1+ or Android 12+) from `mentraglass.com/os`.
- In the console, click "Create App". Set:
  - **Package name:** `build.w.camera-example`
  - **Public URL:** _placeholder for now — we'll update after Step 2_ (use `https://example.com` temporarily; the console requires *something*)
  - **Permissions:** microphone (the example uses voice). Add others if the example needs them.
- Verify the app appears in "My Apps" in the console.

**Gate:**
- [ ] MentraOS account exists and is signed in on both the console and the phone app.
- [ ] App `build.w.camera-example` is registered in the console.
- [ ] Phone is paired with Scott's Mentra Live glasses (Bluetooth pair via the MentraOS phone app — follow in-app prompts).

### Step 2 — ngrok account + static URL

**What:**
- Sign up at ngrok.com (free tier is fine).
- Install ngrok locally: `brew install ngrok` (macOS).
- Run `ngrok config add-authtoken <your_authtoken>` with the token from the ngrok dashboard.
- In the ngrok dashboard, go to **Domains** and create a **Static Domain**. Record the URL (looks like `https://<random>.ngrok-free.app`).
- Go back to the MentraOS console and update the app's Public URL to the static ngrok URL.

**Gate:**
- [ ] `ngrok version` returns successfully on the dev machine.
- [ ] Static ngrok domain exists in the ngrok dashboard.
- [ ] MentraOS console "Public URL" for `build.w.camera-example` is the static ngrok URL.

### Step 3 — Clone the Camera Example App template into `w-build-glasses/app/`

**What:**
- Visit https://github.com/Mentra-Community/MentraOS-Camera-Example-App and click **"Use this template"** → **"Create a new repository"** OR just clone it directly into `w-build-glasses/app/` (don't make a separate repo for this; it lives inside the fork).
- Recommended one-liner: `git clone https://github.com/Mentra-Community/MentraOS-Camera-Example-App.git w-build-glasses/app && rm -rf w-build-glasses/app/.git`
- That dumps the example code into our project, drops its git history so it's tracked under our fork's history.

**Gate:**
- [ ] `w-build-glasses/app/` exists with the Camera Example App's source files.
- [ ] `w-build-glasses/app/package.json` exists and references the Mentra SDK.
- [ ] `git status` from the repo root shows `w-build-glasses/app/` as new, untracked files.

### Step 4 — Local install + env config

**What:**
- `cd w-build-glasses/app`
- `cp .env.example .env`
- Edit `.env`:
  - Set `MENTRAOS_API_KEY` to the value from `console.mentraglass.com` → My Apps → build.w.camera-example → API Keys.
  - Set `PACKAGE_NAME` to `build.w.camera-example`.
  - Set `PORT` to `3000` (or whatever the example expects).
- `bun install` — installs all dependencies.

**Gate:**
- [ ] `bun install` completes without errors.
- [ ] `.env` exists with `MENTRAOS_API_KEY` and `PACKAGE_NAME` set.
- [ ] `.env` is gitignored (check `.gitignore` includes `.env*` or similar — Mentra's example should have this; verify).

### Step 5 — Run the app and expose via ngrok

**What:**
Open two terminal panes.

Pane 1:
```
cd w-build-glasses/app
bun run dev
```
This should start the app on port 3000.

Pane 2:
```
ngrok http --url=<your_static_ngrok_url> 3000
```
This exposes the local app to the internet via the registered static domain.

Both should be left running for the next step.

**Gate:**
- [ ] `bun run dev` runs without errors; logs show the app listening on port 3000.
- [ ] `ngrok http --url=...` shows the static URL pointing at `localhost:3000` and the status is "online".
- [ ] Visiting the static URL in a browser returns a response (likely a JSON `{}` or a simple HTML page — non-error is fine).

### Step 6 — Launch the app from the phone and capture a photo

**What:**
- On the phone, open the MentraOS app.
- Confirm Scott's glasses are still connected (Bluetooth status indicator).
- Find `build.w.camera-example` in the apps list (auto-installed because we're signed into the same account as the console). Tap **Start**.
- Once the app is running, follow the example's instructions (tap to capture, or whatever voice command the example uses).
- A photo should be taken with the glasses' camera and displayed on the phone.

**Gate:**
- [ ] The app appears in the MentraOS phone app's app list.
- [ ] Tapping Start launches the app; status shows "running".
- [ ] A photo capture trigger (whatever the example uses) successfully takes a photo with the glasses.
- [ ] The captured photo appears on the phone.
- [ ] Console log in Pane 1 shows the corresponding request from the relay server.

## ⏸ Pause points

- ⏸ **After Step 3:** Confirm with Damo that `w-build-glasses/app/` is the right place (vs a sibling directory like `w-build-glasses/camera-example/`). **Default if no answer in 30 min:** stay with `app/`.
- ⏸ **After Step 5:** Don't proceed to Step 6 without Scott present (he's the one wearing the glasses for the capture test). If Scott isn't available, **stop here** and resume Step 6 when he is. The earlier steps can be done solo.

## Done criteria

- [ ] All six step gates above are green.
- [ ] A photo taken by Scott's glasses appears on the phone via our running app.
- [ ] The session captures a screenshot of the photo on the phone (proof artifact for BUILD_NOTES).
- [ ] `BUILD_NOTES.md` has a 2026-06-16 (or later) dated entry summarising what shipped, including:
  - The MentraOS account email used
  - The package name registered in the console
  - The static ngrok URL
  - The local directory where the app lives
  - Any surprises learned during execution
- [ ] `goals/0002-w-defect-walkaround-mvp.goal.md` is drafted (executor can leave it in "drafting" status — but the file exists with at least the "Why" and "What already exists" sections filled in).

## Grader

Once the executor believes goal 0001 is done, spawn a fresh subagent with this prompt:

> Read `w-build-glasses/goals/0001-camera-example-running.goal.md` and the diff from this session.
>
> For each item in the **Done criteria** list, attempt to **refute** it. Look for:
> - Gates marked done that weren't actually verified (e.g., "bun install completed" but no log evidence)
> - The "photo on phone" criterion satisfied by a mock or a placeholder rather than an actual captured photo
> - `.env` committed accidentally
> - `BUILD_NOTES.md` entry that's vague rather than specific (no package name, no URL, no surprises noted)
> - `goals/0002` drafted but missing the key sections
>
> For each criterion: PASSED / FAILED / UNCLEAR with a one-sentence justification.

## Distill

When the Grader returns all PASSED:

1. **Update `w-build-glasses/BUILD_NOTES.md`** — append the dated entry described in Done criteria.
2. **Update `w-build-glasses/docs/CURRENT_STATE.md`** — move "Camera Example App" from "not yet attempted" to "working".
3. **No CLAUDE.md update** unless the SDK path or rock changed during execution.
4. **Write `goals/0002-w-defect-walkaround-mvp.goal.md`** — the next goal. Use `TEMPLATE.goal.md` as the base. Cover: replace the example's photo trigger with a voice command, capture 10s of audio narration alongside the photo, POST the payload (photo bytes + audio bytes + timestamp + GPS if available) to a local webhook. No AI yet — just prove the capture pipeline.

## Notes from execution

[Empty — fill in as you work. Anything surprising, broken, or specific to Scott's hardware goes here.]

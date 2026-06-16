# Build Notes — W. Build Glasses

Single source for where-we-are / what's-left / next build. The "Active" section at the top is overwritten each session that ships meaningful state. The dated log below is **append-only**.

This file is the second thing any Claude Code session reads after `CLAUDE.md`.

---

## Active (as of 2026-06-16)

**Currently building:** `goals/0001-camera-example-running.goal.md` — get the MentraOS Camera Example App running end-to-end on Scott's Mentra Live glasses.

**Last ship:** (2026-06-16) — fork of Mentra-Community/MentraOS created at `djdamie/MentraOS`; W. project scaffold laid down in `w-build-glasses/`; goal 0001 written and ready to execute.

**Next up:** Once 0001 lands (Camera Example App running, photos captured, dev loop confirmed live), the next goal will be `0002-w-defect-walkaround-mvp.goal.md` — replace the example's photo-capture trigger with a voice command + audio narration capture, and send the payload to a local webhook.

**Blocked on:**
- Mentra developer console account setup at `console.mentraglass.com` (Damo).
- ngrok account + static URL (Damo).
- Phone paired with Scott's glasses (one of Damo's or Scott's — iOS 15.1+ or Android 12+).

---

## Pending decisions

- **D1 — Voice trigger word.** "Capture", "log", "defect", or "note"? Need to decide before goal 0002. **Decider:** Damo + Scott. **Default if no answer:** "capture this".
- **D2 — Local webhook host for Phase 1.** Damo's laptop (transient) or a small server on Tailscale (persistent)? **Decider:** Damo + Ed. **Decision gate:** when goal 0002 starts.
- **D3 — Inference platform for the first detection layer.** Roboflow Inference (hosted, cheaper for prototyping) or self-hosted YOLOE on a Jetson (matches the fixed-camera plan, more work to set up). **Decider:** Damo + Ed. **Decision gate:** when goal 0003 starts.

---

## Dated log (append-only)

### 2026-06-16 — Fork created, W. scaffold laid down

- ✅ Forked `Mentra-Community/MentraOS` to `djdamie/MentraOS` (default branch `dev`).
- ✅ Root `CLAUDE.md` extended from `@AGENTS.md` to also `@w-build-glasses/CLAUDE.md` so Claude Code sessions at the repo root pick up both upstream and W. instructions.
- ✅ `w-build-glasses/` directory created with:
  - `README.md` — explains the fork posture and the subdir convention
  - `CLAUDE.md` — full project instructions (rock, architecture, standing rules, conventions, active workstream)
  - `BUILD_NOTES.md` — this file
  - `goals/README.md` + `goals/TEMPLATE.goal.md` + `goals/0001-camera-example-running.goal.md`
  - `docs/ARCHITECTURE.md` + `docs/CURRENT_STATE.md`
- ⏳ Goal 0001 ready to execute. Requires: Mentra console account, ngrok static URL, phone paired to Scott's glasses.
- ⚠ Not blocked, just unset: voice trigger word (D1), local webhook host (D2), inference platform (D3). All park-able until they're needed.

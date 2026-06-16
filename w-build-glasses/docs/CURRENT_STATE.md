# Current State — W. Build Glasses

Feature-by-feature audit. What's working, what's scaffolded, what's mocked, what blocks production.

> **Status definitions:**
> - **Working** — shipped, real data flows end-to-end, no known critical gaps.
> - **Scaffolded** — code exists, shape is right, data is hardcoded / mocked / partial.
> - **Mocked** — placeholder UI or stub functions. Not real.
> - **Blocked** — can't progress without an external dependency.
> - **Not started** — on the roadmap but no code yet.

---

## Capture layer (glasses + phone)

| Feature | Status | Notes |
|---|---|---|
| Mentra console account + app registration | Blocked | Damo to set up at console.mentraglass.com during goal 0001. |
| ngrok static domain | Blocked | Damo to set up an account during goal 0001. |
| Phone paired to Scott's glasses | Blocked | Goal 0001 step 1. Needs Scott present briefly. |
| Camera Example App running locally | Not started | Goal 0001 — first thing we build. |
| W. custom voice-trigger capture | Not started | Goal 0002. Depends on 0001. |
| Audio narration recording (10s) | Not started | Goal 0002. |
| Photo + audio + metadata sent to webhook | Not started | Goal 0002. |

---

## Inference layer

| Feature | Status | Notes |
|---|---|---|
| Roboflow account + first model | Not started | Goal 0003/0004 territory. |
| Local webhook receiver | Not started | Goal 0002 — the simplest version (write to disk). |
| Vision model call (Roboflow Inference API) | Not started | Goal 0003. |
| Open-vocab prompts for defect walkaround | Not started | Goal 0003 — initial prompt set ~5 items. |
| Audio response back to glasses | Not started | Goal 0003 — uses MentraOS speaker SDK. |
| Jetson AGX Orin deployment | Not started | Phase 2. Same hardware as the fixed-camera build; share the box. |

---

## W.OS bridge layer

| Feature | Status | Notes |
|---|---|---|
| `wos.camera.glasses_agent` NATS subject | Not started | Schema defined alongside the fixed-camera build in `wos-codebase`. |
| Python bridge service | Not started | Goal 0004/0005. Ed owns the implementation. |
| Monday defect record creation | Not started | Goal 0004/0005. Reuses the pattern from Finance Agent. |
| Slack channel routing | Not started | Goal 0004/0005. |

---

## Known gaps (not yet on the table above)

- **Voice trigger word not chosen.** Need to pick before goal 0002 starts. Default: "capture this" (D1 in `BUILD_NOTES.md`).
- **Hardhat compatibility for Mentra Live not verified.** Need to physically test that the glasses fit under W.'s standard PPE. Important — Scott to confirm during goal 0001 hardware setup.
- **Battery duration for full site days unknown in practice.** 12+ hour nominal but heavy continuous streaming will drain faster. Will surface during goal 0002+.
- **POV privacy policy at client sites.** Hard constraint per CLAUDE.md. Needs a decision and probably a written policy before any deployment beyond Scott's own use.
- **Hot-reload during dev — does ngrok + Relay Server tolerate frequent restarts?** Unknown. Will surface during goal 0001 step 5 onwards.

---

## Demo blockers for the Q3 rock (W. Defect Walkaround v0 — Aug 30)

The list of things that must move from their current status to **Working** before the v0 demo:

- [ ] Capture layer: photo + audio capture triggered by voice on Scott's glasses (goal 0002).
- [ ] Inference layer: defect prompt set returns useful detections on real W. site photos (goal 0003).
- [ ] Audio whisper response to the wearer (goal 0003).
- [ ] W.OS bridge: at least one finding lands in Monday as a structured defect record (goal 0004).
- [ ] One full session walked end-to-end on a real W. site (Hedges, Mosman, or another active site). Scott or Mitch as user.
- [ ] Privacy policy signed off (Scott + Sat).
- [ ] Hardhat compatibility verified on a real site visit.

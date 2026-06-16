# Architecture (working summary) — W. Build Glasses

Damo's working summary distilled from the source-of-truth specs in `docs/superpowers/specs/` (none committed yet — this evolves as the project ships). Use this file for fast orientation.

> **Source-of-truth hierarchy:**
> 1. `docs/superpowers/specs/[primary spec]` — canonical design docs as they're written. Verbatim, don't edit retroactively.
> 2. **This file** — working summary that evolves as decisions close.
> 3. `docs/CURRENT_STATE.md` — feature-by-feature audit of what's actually working.

---

## System shape (one paragraph)

A worker (PM, Supe, or eventually a tradie) wears Mentra Live glasses on a site walk. A voice command triggers the W. app on the paired phone to capture a photo + a short audio clip from the glasses. The capture is sent to a webhook the W. team controls, which runs the photo through a vision model (YOLOE or Roboflow Inference) with prompts the W. team has tuned for the use case (defect walkaround, subcontractor verification, etc). The model's finding is whispered back to the wearer via the glasses' speakers, **and** published to W.OS on the NATS event bus where existing agents create structured records in Monday and Slack.

---

## The three layers

### Layer 1 — Glasses + phone (the capture layer)

- **Hardware:** Mentra Live (Scott's pair, $349 USD). 12MP camera, 119° FOV, stereo speakers, 3 mics. No on-device AI.
- **Paired phone:** iOS 15.1+ or Android 12+ running the MentraOS app. The phone is the bridge between the glasses and our app code.
- **Our code:** TypeScript app using the MentraOS Cloud SDK, communicating with the glasses through the **Mentra Relay Server** in development and (Phase 2) the Bluetooth SDK directly in production.
- **Trigger pattern:** voice command (Phase 1) → photo capture + short audio narration → POST to our webhook.

### Layer 2 — Inference (the detection layer)

- **Phase 1 (prototyping):** Roboflow Inference, hosted serverless API. We POST the photo, we get JSON back with detections.
- **Phase 2 (production):** Self-hosted YOLOE on a Jetson AGX Orin on a Tailscale-connected machine. Same hardware we're buying for the fixed-camera build.
- **Prompts:** Open-vocabulary detection. Each use case has a prompt set (e.g., defect walkaround: `["cracked plasterboard", "missing flashing", "exposed cable", "incorrect tile alignment", "water damage"]`).
- **Response shape:** `{ "detected": [{ "label": "...", "confidence": 0.87, "bbox": [...] }], "interpretation": "Cracked plasterboard, 30cm along the joint" }`.

### Layer 3 — W.OS (the agent layer)

- **NATS event bus:** Inference findings publish to `wos.camera.glasses_agent`. Same back-end the fixed-camera findings will use, just a different subject.
- **W.OS bridge service:** Python service Ed owns. Subscribes to glasses events; creates structured defect records in Monday; posts summaries to Slack channels; routes to relevant on-site PMs.
- **Codebase:** lives in `wos-codebase` (sister repo), not in this fork.

---

## How the layers communicate

```
    Glasses
      │ Bluetooth (camera + mic)
      ▼
    Phone (MentraOS app)
      │ MentraOS Relay Server (Phase 1)
      ▼
    Our W. app (TypeScript, Bun, ngrok-exposed)
      │ HTTP POST (photo + audio + metadata)
      ▼
    Inference layer (Roboflow Phase 1 / Jetson Phase 2)
      │ JSON detection response
      ▼
    Our W. app
      │ (a) Audio whisper back via MentraOS SDK
      │ (b) HTTP POST to W.OS bridge
      ▼
    W.OS bridge
      │ NATS publish to wos.camera.glasses_agent
      ▼
    W.OS agents → Monday + Slack
```

---

## Open decisions

- **D1 — Voice trigger word.** "Capture", "log", "defect", or "note"? Need to decide before goal 0002. **Decider:** Damo + Scott.
- **D2 — Local webhook host for Phase 1.** Damo's laptop (transient) or a small server on Tailscale (persistent)? **Decider:** Damo + Ed.
- **D3 — Inference platform for the first detection layer.** Roboflow Inference (hosted, cheaper for prototyping) or self-hosted YOLOE on a Jetson? **Decider:** Damo + Ed. **Decision gate:** when goal 0003 starts.
- **D4 — Bluetooth SDK migration timing.** When do we move off the Relay Server / ngrok and into a native pairing? **Decider:** Damo. **Decision gate:** when MentraOS 3.0 ships (summer 2026) — that may obviate the question.
- **D5 — Privacy policy for POV recording at client sites.** Required before any deployment beyond Scott's own walking. **Decider:** Scott + Sat.

---

## Closed decisions (with rationale)

- **Mentra Live over Even Realities, Vuzix, Meta Ray-Bans.** Open-source SDK was the deciding factor. Multi-hardware OS support is a hedge — if we want to switch glasses later, the code mostly carries over.
- **Cloud SDK over Bluetooth SDK for Phase 1.** Faster setup, lets us prove the loop. Bluetooth SDK is the production path; just not the prototype path.
- **Fork the full MentraOS repo over forking the Camera Example App.** Visibility into the OS, ability to track upstream changes, optionality on contributing back. (Decided 2026-06-16 with Damo + Sat.)
- **Inference happens off-glasses, not on.** Mentra Live's MediaTek MTK8766 chipset isn't an AI accelerator. Phone or Jetson does the work. (Architectural constraint, not a decision.)

---

## What's evolving (and what to expect next)

- **MentraOS 3.0** lands summer 2026 with on-phone apps that don't need the Relay Server. Likely simplifies the deployment story considerably.
- **Mentra Display** (the AR-overlay hardware) is on the 2026 roadmap. If/when it ships, the "audio whisper" output channel can be extended to a visual overlay channel.
- **W.OS NATS event schema** for `wos.camera.*` is being finalised as part of the fixed-camera build. When that schema lands, our glasses bridge updates to match it.

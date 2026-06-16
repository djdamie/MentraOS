<!--

  ⚠️  STOP — CHECK THE BASE REPO  ⚠️

  This is W. / ELYCIUM's fork of MentraOS.

  Look at the top of this page where it says
  "base repository:" and "base:".

  If it says:

    base repository: Mentra-Community/MentraOS

  ❌ STOP. That would push our work upstream to the public Mentra repo.
     Change "base repository" to:  djdamie/MentraOS
     Change "base:" to:             w-build/main

  If it says:

    base repository: djdamie/MentraOS  →  base: w-build/main

  ✅ Good — this PR stays within our fork.

  Default-target this repository attempts to enforce is `w-build/main`.
  If you're seeing anything else as the base, GitHub has guessed wrong.

-->

## What this changes

<!-- 1–3 sentences. What's the user-visible or system-visible change. -->

## Goal file this ladders into

<!-- Link the `w-build-glasses/goals/<NNNN>-*.goal.md` this PR is executing against, if any. -->

## Verification

<!-- How did you check this works? Logs, screenshots, manual steps, test names. -->

## Checklist

- [ ] Base repository is `djdamie/MentraOS` (not `Mentra-Community/MentraOS`)
- [ ] Base branch is `w-build/main` (not `dev` or `main`)
- [ ] `.env` and any secrets are gitignored, not in this diff
- [ ] If a goal file's Done criteria changed, `BUILD_NOTES.md` reflects the new state
- [ ] If this changes anything in the upstream tree (outside `w-build-glasses/`), that change is intentional and documented in the description above

# Contributing to W. Build Glasses

How the W. team works in this fork, and how to not accidentally push our work to the upstream public Mentra repo.

This file applies to everyone working in `w-build-glasses/`. Read once. Then bookmark.

## The risk we're managing

This repo is a **fork** of `Mentra-Community/MentraOS`. Forks come with a footgun: GitHub's "Compare & pull request" UI defaults the base of a new PR to the **upstream** repository, not your fork. Click "Create pull request" without checking, and your team's W.-specific work becomes a public PR against the Mentra public repo.

We have four layers of protection. Don't skip any of them.

## Layer 1 — Our default branch is `w-build/main`, not `dev`

The fork's default branch has been changed from `dev` (upstream's name) to `w-build/main`. This means:

- `git clone https://github.com/djdamie/MentraOS.git` checks out `w-build/main` by default.
- The "Compare & pull request" UI defaults to `djdamie/MentraOS:w-build/main` as the base, not `Mentra-Community/MentraOS:dev`.
- `dev` still exists and stays in sync with upstream so we can fetch new MentraOS changes — but **we never commit to `dev`**.

**All team work happens on feature branches off `w-build/main`.** Feature branches merge back into `w-build/main` via PR. `dev` is read-only for our purposes.

## Layer 2 — Local git config (do this once after cloning)

The first time you clone the repo on a new machine, run these commands at the repo root:

```bash
# Make sure pushes default to our fork, never anywhere else
git config remote.pushDefault origin

# Optional but recommended: add upstream as a fetch-only remote so you can
# sync MentraOS changes without ever being able to push to them by accident.
git remote add upstream https://github.com/Mentra-Community/MentraOS.git
git remote set-url --push upstream DISABLED
git config remote.upstream.tagOpt --no-tags

# Verify
git remote -v
# Expected output:
#   origin    https://github.com/djdamie/MentraOS.git (fetch)
#   origin    https://github.com/djdamie/MentraOS.git (push)
#   upstream  https://github.com/Mentra-Community/MentraOS.git (fetch)
#   upstream  DISABLED (push)
```

`git push upstream <anything>` will now error immediately. Belt and braces.

## Layer 3 — The PR template

`.github/PULL_REQUEST_TEMPLATE.md` shows a big warning at the top of every PR description, telling you to check the base repository before creating. Read it every time. It's there for a reason.

## Layer 4 — Branch protection on `w-build/main`

`w-build/main` is protected. To merge into it you need:

- A passing CI run (when CI is set up)
- At least one approving PR review

This means even if all the above fails, the worst case is a PR sitting open that someone has to approve. It can't be silently merged.

## Conductor conventions

We use [Conductor](https://conductor.dev/) (or any Claude Code worktree manager) for parallel work. Each goal in `w-build-glasses/goals/` runs in its own worktree.

**Per-worktree convention:**

- Worktree branch name: `w-build/goal-<NNNN>-<short-name>` — e.g., `w-build/goal-0001-camera-example-running`.
- Worktree base: branches off `w-build/main`.
- PRs from a worktree branch target `w-build/main`. Never `dev`. Never upstream.

**When you create a new worktree, first thing to do** (before opening Claude Code in it):

```bash
# Inside the new worktree directory
git config remote.pushDefault origin
git remote -v  # confirm only origin (and optionally upstream as fetch-only) are set
```

Conductor inherits the parent clone's remote config, so if you did Layer 2 on the parent, you usually don't need to redo this — but verify with `git remote -v` anyway.

**Naming the Conductor session:** match the goal file name. Session `goal-0001-camera-example-running` runs against `w-build-glasses/goals/0001-camera-example-running.goal.md`. That way someone glancing at the Conductor sidebar sees what's in flight at a glance.

## Syncing from upstream MentraOS

When new changes land in `Mentra-Community/MentraOS:dev` that we want:

```bash
# Make sure you're on dev (NOT w-build/main)
git checkout dev

# Fetch upstream's changes
git fetch upstream

# Fast-forward our dev to upstream's dev
git merge --ff-only upstream/dev

# Push our updated dev to our fork (this is the only time we push dev)
git push origin dev

# Now bring those changes into our work
git checkout w-build/main
git merge dev
# Resolve any conflicts (usually only in our w-build-glasses/ dir if upstream touched it, which it shouldn't)
git push origin w-build/main
```

`dev` is a tracking line for upstream. We don't develop on it. We just keep it pointed at upstream so we can pull from there into `w-build/main`.

## What if you accidentally push to the wrong place

Don't panic. Tell Damo immediately. Two scenarios:

- **You pushed our work to upstream (`Mentra-Community/MentraOS`).** This is the worst case. The commits are on a branch in the public repo. Damo or someone with permissions can delete the branch via the GitHub UI (it doesn't require admin rights on the upstream repo — branch deletion in a fork-target context still works for branches you created). If a PR was also created, close it. **Don't try to fix this silently.**
- **You opened a PR against upstream but haven't merged it.** Close the PR. Re-open it with the correct base (`djdamie/MentraOS:w-build/main`). No harm done if it's caught before merge.

## TL;DR

- Default branch is `w-build/main`, not `dev`.
- Work on `w-build/goal-<NNNN>-*` branches.
- Run the Layer 2 git config once per machine.
- Always check the PR base repo before clicking Create.
- Sync upstream via `dev`, never develop on `dev`.
- If you mess up, tell Damo. Don't try to silently un-mess-up.

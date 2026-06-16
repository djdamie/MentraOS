# Goal: [NAME]

**Created:** [YYYY-MM-DD]
**Status:** drafting / ready to execute / in-flight / done / abandoned
**Author of this goal:** [name]
**Executor (when started):** [name or "any session"]

## Why this goal exists

[One paragraph: what problem this goal solves, why it's worth doing now, and how it ladders into the current rock / milestone in CLAUDE.md.]

## What already exists

[The current state of the codebase as it relates to this goal. Be specific:
- Files that already exist and what they do
- Schema columns already in place
- Components already wired up
- Anything that's mocked or scaffolded that this goal will replace]

Reference: `BUILD_NOTES.md` — read the dated log entries from the last 2–3 sessions for context.

## Read first (in this order)

The executing session must read these *before* starting any code:

1. [Spec, doc, or file path] — [why it matters for this goal]
2. [Next reference]
3. [...]

If any of these specs are missing or out of date, **stop and surface that** rather than guessing.

## Locked conventions

Decisions already made. Don't relitigate mid-flight. If one of these turns out to be wrong, pause and escalate.

- [Convention 1] — [why]
- [Convention 2] — [why]

## Run order

Each item below has a **verification gate**. Don't move to the next item until the current item's gate passes. If a gate fails, loop on that item until green; don't paper over it.

### Step 1 — [name]

**What:** [Specific action. File paths. Function names where relevant.]

**Gate:**
- [ ] [Verifiable check 1]
- [ ] [Verifiable check 2]

### Step 2 — [name]

**What:** [...]

**Gate:**
- [ ] [...]

## ⏸ Pause points

- ⏸ After Step [N]: [Decision question]. **Decider:** [name]. **Default if no answer in [time]:** [fallback].

## Done criteria

The goal is complete when every box below can be ticked **and** the Grader (next section) cannot refute any of them.

- [ ] [Criterion 1 — specific, observable]
- [ ] [Criterion 2]
- [ ] `BUILD_NOTES.md` has a dated entry summarising what shipped.
- [ ] The next goal file is drafted to `goals/<NNNN+1>-<name>.goal.md` (or the explicit decision "no next goal yet, waiting on X" is captured in BUILD_NOTES).

## Grader

Once the executor believes the goal is done, spawn a **fresh subagent** with this prompt:

> Read `goals/<this-file>.goal.md` and the diff from this build session.
>
> For each item in the **Done criteria** list, attempt to **refute** it. Find a reason it might not be met.
>
> For each criterion: state PASSED / FAILED / UNCLEAR, with a one-sentence justification.
> If anything is FAILED or UNCLEAR, the goal is not done. Loop back to fix.

## Distill

Once the Grader returns all PASSED:

1. **Update `BUILD_NOTES.md`** — prepend a dated entry to the log.
2. **Update `CLAUDE.md` if** — the active rock changed or a standing rule changed.
3. **Update `docs/ARCHITECTURE.md` if** — an open decision closed.
4. **Update `docs/CURRENT_STATE.md` if** — a feature crossed a mocked / scaffolded / working / broken boundary.
5. **Write the next goal file** while context is hot.

## Notes from execution

[Free-form area for the executing session to drop observations, surprises, gotchas. Leave empty at goal-creation time; fill in as you work.]

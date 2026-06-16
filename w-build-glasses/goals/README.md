# goals/

This directory is where substantial build work for the W. Glasses project lives. Each `<NNNN>-<name>.goal.md` is a rubric that a Claude Code session (or a teammate, or a Conductor worktree) hill-climbs against until every checkbox passes.

## The shape (use `TEMPLATE.goal.md`)

```
what already exists
  → read first (specific files, in order)
  → locked conventions (don't relitigate these mid-flight)
  → run order — each item has a verification gate
                (loop until green before the next item)
  → ⏸ pause points where a named human decides
  → checkable done criteria
  → Grader — a fresh subagent told to *refute* each criterion against the diff
  → distill what the work taught into BUILD_NOTES.md
  → write the next goal file while context is hot
```

## Files

- **`TEMPLATE.goal.md`** — copy this when you create a new goal.
- **`0001-camera-example-running.goal.md`** — first goal. Get the MentraOS Camera Example App running on Scott's Mentra Live glasses.
- (More to come as the project progresses.)

## Numbering

Goal files are numbered in the order they're created: `0001-camera-example-running`, `0002-w-defect-walkaround-mvp`, etc. Once written, the file lives as a permanent record even after the work ships — it's how the next person walks into the repo and understands what was built, in what order, and why.

For the broader pattern explanation see [`w-project-template/goals/README.md`](https://github.com/djdamie/w-project-template/blob/main/goals/README.md).

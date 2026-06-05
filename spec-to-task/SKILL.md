---
name: spec-to-task
description: Break down the spec into tasks
---

Break this spec into trackable and testable slice: $ARGUMENTS

## Rules

- Decompose the spec's into vertical slices.
- Decompose each vertical slice into executable tasks.
- A task is too big if its acceptance criteria need the word "and" to describe separate outcomes - split it.
- Order tasks by dependency. State each task's dependencies explicitly by ID.
- Give every task acceptance criteria: how we know it's done, in observable terms (test passes, endpoint returns X, file exists).
- Don't invent work the spec didn't decide. If a step is underspecified, add it to **Open** instead of guessing.
- Don't start executing. This command produces the task list only.

## Tracking

- Every task is a todo checkbox: `- [ ]` open, `- [x]` done.
- A task is marked `- [x]` only when its acceptance criteria are met.
- Keep `tasks.md` as the live source of truth — update the checkbox as each task completes so progress and remaining work are always readable from the file.

## Output

Write to `$PWD/specs/{slug}/tasks.md` alongside the spec.

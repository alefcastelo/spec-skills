---
name: archive
description: Archive an executed spec or standalone plan
effort: max
---

Archive the spec directory (`SPEC.md` + `TASK.md`), or a standalone plan directory (`PLAN.md`), once its work is done: $ARGUMENTS

## Completion check

- Read the track — `TASK.md` for a spec, `PLAN.md` for a standalone plan. It is complete only when every task is `- [x] ✅` with a commit reference and the **Open** section is empty. `Status: ✅ complete` on the track is the expected signal (tracks predating the status line pass on the tasks alone).
- For a spec, read every nested plan under `plans/{plan-slug}/PLAN.md` too. The spec archives only when its own track AND all of them are complete.
- If any task is `- [ ]` — a ✋ task especially, it's waiting on the user — or **Open** is non-empty, do NOT archive. List the unfinished tasks and open items — naming the track each one belongs to — then stop.

## Archive

- Move the whole folder to `$PWD/.ai/archive/` with `mv`, keeping its name `<Y-m-d>-<slug>` — the date stays the creation date, so archives sort by when the work started. `EXPLORE.md`, `SPEC.md`, `TASK.md` or `PLAN.md`, and the whole `plans/` directory move with it.
- A nested plan NEVER archives on its own. It archives when the spec that owns it does, inside that move.
- Never delete — archiving is a move, always reversible by moving it back.
- If `.ai/archive/<Y-m-d>-<slug>/` already exists, stop and ask rather than overwriting.

## Summary

For a spec or plan, write `$PWD/.ai/archive/<Y-m-d>-<slug>/summary.md`:

- One line per requirement (`R1`, `R2`, …) from `SPEC.md`: what shipped, in plain language.
- The tasks (`T-N`) that delivered it, with their commit references from `TASK.md`.
- What we decided along the way that isn't obvious from the code, and anything that changed from the original design.

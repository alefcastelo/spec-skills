---
name: archive
description: Archive an executed spec or standalone plan
---

Archive the spec directory (`SPEC.md` + `TASK.md`), or a standalone plan directory (`PLAN.md`), once its tasks are all implemented: $ARGUMENTS

## Completion check

- Read the track — `TASK.md` for a spec, `PLAN.md` for a standalone plan. It is complete only when every task is `- [x]` with a commit reference and the **Open** section is empty.
- For a spec, read every nested plan under `plans/{plan-slug}/PLAN.md` too. The spec archives only when its own track AND all of them are complete.
- If any task is `- [ ]` or **Open** is non-empty, do NOT archive. List the unfinished tasks and open items — naming the track each one belongs to — then stop.

## Archive

- Resolve today's date as `YYYY-MM-DD` (run `date +%F`).
- Move the whole directory to `$PWD/specs/archive/{date}-{slug}/` with `mv`, so archives sort chronologically. `SPEC.md`, `TASK.md` or `PLAN.md`, and the whole `plans/` directory move with it.
- A nested plan NEVER archives on its own. It archives when the spec that owns it does, inside that move.
- Never delete — archiving is a move, always reversible by moving it back.
- If `specs/archive/{date}-{slug}/` already exists, stop and ask rather than overwriting.

## Learnings — mandatory

The archive does not conclude without this step.

- MUST: Extract the learning candidates from this execution — decisions taken, mistakes corrected, course changes recorded in the track's history, **Open** notes and the summary.
- MUST: Run the `/learning` flow on every candidate. Each one is stored only with the user's explicit approval, per that skill's rules (validation, INDEX line + detailed doc, overlap check, supersede vs refine).
- MUST: Accept "no learning from this execution" as a valid outcome — but only after asking, with the user confirming it.
- DON'T: Store anything directly from here. `/learning` is the only gate to `docs/learnings/`.

## Summary

Write `$PWD/specs/archive/{date}-{slug}/summary.md`:

- One line per requirement (`R1`, `R2`, …) from `SPEC.md`: what shipped, in plain language.
- The tasks (`T-N`) that delivered it, with their commit references from `TASK.md`.
- What we decided along the way that isn't obvious from the code, and anything that changed from the original design.

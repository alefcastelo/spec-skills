---
name: archive
description: Archive an executed spec, standalone plan, or research document
effort: max
---

Archive the spec directory (`SPEC.md` + `TASK.md`), a standalone plan directory (`PLAN.md`), or a research document (`docs/research/{slug}.md`), once its work is done: $ARGUMENTS

## Completion check

- Read the track — `TASK.md` for a spec, `PLAN.md` for a standalone plan. It is complete only when every task is `- [x] ✅` with a commit reference and the **Open** section is empty. `Status: ✅ complete` on the track is the expected signal (tracks predating the status line pass on the tasks alone).
- For a spec, read every nested plan under `plans/{plan-slug}/PLAN.md` too. The spec archives only when its own track AND all of them are complete.
- If any task is `- [ ]` — a ✋ task especially, it's waiting on the user — or **Open** is non-empty, do NOT archive. List the unfinished tasks and open items — naming the track each one belongs to — then stop.
- A research document has no tasks — it archives when the user says it's done (it fed its PRD/spec, or they're closing it). If its **Open** section still lists hypotheses, show them and get explicit confirmation before archiving.

## Archive

- Resolve today's date as `YYYY-MM-DD` (run `date +%F`).
- Move the whole directory to `$PWD/specs/archive/{date}-{slug}/` with `mv`, so archives sort chronologically. `SPEC.md`, `TASK.md` or `PLAN.md`, and the whole `plans/` directory move with it.
- A research document moves to `$PWD/docs/research/archive/{date}-{slug}.md` instead, and its `Status:` line flips to `Status: 📦 archived`.
- A nested plan NEVER archives on its own. It archives when the spec that owns it does, inside that move.
- Never delete — archiving is a move, always reversible by moving it back.
- If `specs/archive/{date}-{slug}/` already exists, stop and ask rather than overwriting.

## Learnings — mandatory

The archive does not conclude without this step.

- MUST: Extract the learning candidates from this execution — decisions taken, mistakes corrected, course changes recorded in the track's history, **Open** notes and the summary. For a research document: refuted hypotheses, source conflicts, and anything the research settled that future work must not re-litigate.
- MUST: Run the `/learning` flow on every candidate. Each one is stored only with the user's explicit approval, per that skill's rules — `/learning` owns the how.
- MUST: Accept "no learning from this execution" as a valid outcome — but only after asking, with the user confirming it.
- DON'T: Store anything directly from here. `/learning` is the only gate to `docs/learnings/`.

## Summary

A research document needs no summary — its sections already are the summary. For a spec or plan, write `$PWD/specs/archive/{date}-{slug}/summary.md`:

- One line per requirement (`R1`, `R2`, …) from `SPEC.md`: what shipped, in plain language.
- The tasks (`T-N`) that delivered it, with their commit references from `TASK.md`.
- What we decided along the way that isn't obvious from the code, and anything that changed from the original design.

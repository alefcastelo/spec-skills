---
name: write-tasks
description: Break an agreed spec into shippable slices and the tasks that build them
---

You will read the agreed spec and break it into slices, each slice into tasks, writing them to `TASK.md`: $ARGUMENTS

$ARGUMENTS is the slug or path of a spec under `$PWD/specs/`. If it's missing or matches more than one, ask me which — don't pick for me.

The spec is settled. This command turns it into a track; it doesn't reopen the design.

## Slices

A slice is a logical group of changes that must go together. Once its tasks are done, I can ship it to prod. It doesn't have to be a feature:

- **a requirement** — the user fills the form, presses the button, and a record is created in the database
- **a UI refactor** — every card is consistent with the design
- **an anti-pattern refactor** — no null coalescing operator anywhere
- **a database change** — contact e-mails move to a one-to-many relationship so we can persist more than one

Rules:

- MUST: Give every slice an ID (`S1`, `S2`, …) and a title that says what shipping it changes.
- MUST: Make every slice shippable on its own — the product works with it merged and nothing after it merged.
- MUST: Order slices so a slice depends only on earlier ones, never on a later one.
- MUST: Keep a change in the same slice as the changes that can't ship without it. A migration whose code isn't written yet, or a UI that reads a column nobody writes, belongs with its other half.
- DON'T: Split a slice because it's big. Split it when each half ships on its own.
- DON'T: Group by layer. "All the migrations", then "all the endpoints", is a horizontal slice — neither half ships.

## Tasks

- MUST: Every task traces to a requirement. A task that references no `R-ID` is work we didn't agree on.
- MUST: Give every task acceptance criteria: the requirement(s) it satisfies, in observable terms.
- MUST: Split a task whose acceptance criteria need the word "and" to describe separate outcomes.
- MUST: Number tasks `T1`, `T2`, … in dependency order across the whole spec, so a blocker's number always precedes its dependents.
- MUST: Give each blocked task a `Blocked by: T-N` line listing every blocker. No `Blocked by` line means the task is parallelizable — it depends on no one.

Task body:

- Requirement reference (`R1`, `R2`, …) and its acceptance criteria from the spec.
- Technical notes from the spec for that slice.
- The repository it changes, when the checkout spans more than one.
- `Blocked by: T-N` when applicable.

## Rules

- MUST: Read the whole `SPEC.md` before writing a single task.
- MUST: Read the code before asking me anything. The code is the unique truth — a step that looks underspecified is usually already answered by an existing endpoint, output, component or repository. Investigate first; ask only what the code cannot know.
- MUST: Resolve every underspecified step before writing `TASK.md` — from the code when the code answers it, from me when only I can. `TASK.md` ships with no **Open** section: a step parked there comes back as an interruption in the middle of `/implement`.
- MUST: Fold the answer into the task that needs it, and say in that task that it came from the code or from me.
- SHOULD: Investigate the codebase when you need a fact to size, slice, or order a task — dispatch a sub-agent rather than guessing.
- DON'T: Invent work we didn't decide.
- DON'T: Reopen the WHAT or the HOW. If the spec turns out unworkable or self-contradictory, stop and say so — don't design your way around it.
- DON'T: Start executing. This command produces `TASK.md` only.

## Output

Write `TASK.md` next to the spec, in `$PWD/specs/{slug}/`.

`TASK.md` — the local track, live source of truth. One section per slice, its tasks under it:

```
## S1 — Contact e-mails become one-to-many

- [ ] T-1 — Add contact_emails table and migration — repo: api — commit: —
- [ ] T-2 — Move the existing contact e-mail into the new table — repo: api — blocked by: T-1 — commit: —
```

- One checkbox line per task: `- [ ] T-N — title — repo: <repo> — blocked by: T-M — commit: —`
- `- [x]` only when the task is implemented; `/implement` fills the commit reference and flips the checkbox.
- A slice is shippable when every task under it is `- [x]` — it carries no checkbox of its own.
- No **Open** section. `/implement` reserves it for blockers found while implementing; nothing is parked there in advance.

Then tell me the track is ready for `/implement`, listing anything I decided during this run that the spec didn't already say.

---
name: write-tasks
description: Break an agreed spec into shippable slices and the tasks that build them
effort: max
---

You will read the agreed spec and break it into slices, each slice into tasks, writing them to `TASK.md`: $ARGUMENTS

$ARGUMENTS is the slug or path of a spec under `$PWD/.ai/`. If it's missing or matches more than one, ask me which — don't pick for me.

The spec is settled. This command turns it into a track; it doesn't reopen the design — adding a 🧹 refactor within reach is not reopening it.

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

## PRs

Slices ship in PRs. A track is one PR or a stack of them, merged in order — decided by judgement, never by size.

- MUST: Group the slices under `## PR N — title` headings, in merge order. Every track has at least one.
- MUST: Make every PR mergeable in order — the product works with it merged and nothing after it.
- MUST: Place each 🧹 refactor from the spec by what it does to the main change:
  - **a PR before** the main one, when the feature builds on it;
  - **a PR after**, when it is cleanup that would only add noise to the main diff;
  - **an own commit inside the main PR**, when it is small and touches the same lines — mark its task `own commit`.
- MUST: Apply **Continuous refactoring** from `/specify` to the code you read while slicing — a refactor within reach that the spec lacks goes into the spec as a 🧹 requirement, decided per the decision rule, and into a PR like any other.
- DON'T: Split PRs by size. Split them when each one makes sense to review and merge on its own.

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

Write `TASK.md` next to the spec, in its `$PWD/.ai/<Y-m-d>-<slug>/` folder.

`TASK.md` — the local track, live source of truth. It opens with a status line, then one `## PR` section per PR in merge order, its `### S` slices under it, each slice's tasks under the slice:

```
# TASK — {slug}

Status: 🔍 ready to implement

## PR 1 — 🧹 Contacts validate through the shared EmailAddress

### S1 — The contact form uses EmailAddress

- [ ] T-1 — 🧹 Replace the inline regex in ContactForm with EmailAddress — repo: api — commit: —

## PR 2 — Contact e-mails become one-to-many

### S2 — Contacts keep many e-mails

- [ ] T-2 — Add contact_emails table and migration — repo: api — blocked by: T-1 — commit: —
- [ ] T-3 — Move the existing contact e-mail into the new table — repo: api — blocked by: T-2 — commit: —
- [ ] T-4 — 🧹 Rename ContactRepo to ContactRepository — repo: api — own commit — commit: —
```

- One checkbox line per task: `- [ ] T-N — title — repo: <repo> — blocked by: T-M — own commit — commit: —` — `blocked by` only when it depends on another task, `own commit` only for a 🧹 refactor committed alone inside its PR; no status emoji at creation, the task hasn't started.
- Status emojis are written by `/implement` as it runs: 🚀 task started, `- [x] ✅` task done (with the commit reference filled), ✋ task waiting on the user. The `Status:` line moves `🔍 ready to implement` → `🚀 implementing` → `✅ complete` (or `✋ blocked`).
- A slice is shippable when every task under it is `- [x] ✅` — it carries no checkbox of its own.
- A PR heading carries no checkbox either — it is done when all its slices are.
- No **Open** section. `/implement` reserves it for blockers found while implementing; nothing is parked there in advance.

Then list anything I decided during this run that the spec didn't already say, and invoke the `validate` skill via the Skill tool with `{slug}` — don't stop to ask me first.

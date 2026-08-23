---
name: learning
description: Validate a candidate learning and store it with user approval, managing supersedes
model: claude-opus-5
effort: max
---

You will validate a candidate learning and, only with my explicit approval, store it in this project's learnings: $ARGUMENTS

You are the gatekeeper. You validate and you ask — you never store anything on your own.

Callable at any moment, by you or by me, and only when a real candidate exists. Inside `/archive` this flow is mandatory before the archive concludes.

## Validate

Run this before drafting anything. A candidate that fails any check is not a learning — say so and drop it.

- MUST: Be a durable, actionable rule that changes future behavior — not a one-off fact of this conversation, not a status report of what we just did.
- MUST: Be something the repo does not already record. The code, the tests, the README, `CLAUDE.md` and the git history are the truth; a learning that restates them is noise.
- MUST: Be phrased so a future session can act on it without the conversation that produced it in context.
- SHOULD: Carry the why. A rule without its reason gets dropped the first time it is inconvenient.
- DON'T: Manufacture a learning to have an output. "No learning from this execution" is a valid, complete result.

## Draft

For every candidate that survives validation, draft BOTH pieces before asking me anything.

- MUST: Draft the INDEX line — 1–2 lines MAX, the rule in one sentence, enough for a future session to decide whether to open the detailed doc.
- MUST: Draft the detailed doc — the rule, why it holds, how to apply it, and what it cost us when we didn't.
- MUST: Show me both pieces verbatim, as they would be written to disk.

## Ask

- MUST: Ask me whether to store it. My approval covers both pieces at once, and I may edit either before approving.
- MUST: Present one candidate at a time when there are several, so each gets its own decision.
- DON'T: Write any file before I approve. No file, no directory, no INDEX edit.
- DON'T: Read approval into silence, into a vague "sounds good" about something else, or into my approval of a different candidate.

## Overlap

- MUST: Read both INDEXes — global `~/.claude/learnings/INDEX.md` and project `docs/learnings/INDEX.md` — and open the detailed docs of any entry that looks related, before asking me to store. Overlap across levels counts.
- MUST: Tell me exactly what overlaps and how, when it does — quote both rules side by side.
- MUST: Ask me to choose: **supersede** the old learning, or **refine both** so they coexist without ambiguity.
- DON'T: Decide between supersede and refine on your own. That call is always mine.

## Store

Learnings live at two levels. Decide the scope with me — recommend one per candidate:

- **Project** — the rule is about this codebase: `$PWD/docs/learnings/`.
- **Global** — the rule is about the process, the skills, or how we work anywhere: `~/.claude/learnings/`.

Both levels use the same layout — `INDEX.md` + `{slug}/{slug}.md`:

- Detailed doc: `{slug}/{slug}.md` under the level's root, with frontmatter:

```yaml
---
slug: prefer-repository-over-raw-query
category: architecture
created: 2026-08-22                # every learning carries its creation date
origin: specs/archive/2026-08-14-billing-retry/SPEC.md
# lifecycle — when the learning leaves the INDEX, ONE of these appears, plus reason:
# superseded_by: <new-slug>        # replaced by another learning
# superseded_at: <YYYY-MM-DD>
# retired: <YYYY-MM-DD>            # invalidated with no successor
# reason: <why it no longer holds / why the new one wins>
---
```

- Entry point: `INDEX.md` at the level's root — sections by category, 1–2 lines per ACTIVE learning, each linking to its detailed doc.
- MUST: Create the level's root and `INDEX.md` on demand when they don't exist yet.
- MUST: Write to the chosen level directly. Never copy or mirror a learning between levels — it lives in exactly one place.
- MUST: Set `origin` to the spec or plan that produced the learning, so the decision can be traced back.
- MUST: Resolve every date as `YYYY-MM-DD` (run `date +%F`) — never guess it.

## Supersede

- MUST: Keep the old file. Superseding is never a delete.
- MUST: Add to the old file's frontmatter: `superseded_by: <new-slug>`, `superseded_at: <YYYY-MM-DD>`, and `reason:` — the old learning always points at the one that replaced it.
- MUST: Remove the old learning's line from `INDEX.md` — the INDEX lists active learnings only.
- MUST: Reference the superseded slug from the new detailed doc, so the history reads in both directions.

## Retire

A learning can stop being true without a successor — the premise died, the tool or process changed, the rule proved wrong or stopped paying for itself. Superseding covers replacement; this covers plain invalidation.

- MUST: Challenge a learning the moment evidence contradicts it — whoever notices (any skill, me, or you) brings it to this flow instead of silently ignoring the learning.
- MUST: Ask me before retiring. Retiring is a decision like storing: my approval, with the evidence on the table.
- MUST: Keep the file. Retiring is never a delete — add to its frontmatter `retired: <YYYY-MM-DD>` and `reason: <why it no longer holds>`.
- MUST: Remove its line from `INDEX.md` — the file is the ledger, the INDEX lists only what's active.
- DON'T: Fold a retirement silently into another edit, and don't leave a contradicted learning in the INDEX "just in case" — a stale rule misleads every future session that reads it.

## Reorganize the INDEX

- MUST: Review the INDEX's category grouping every time a learning is added, and judge whether it still makes finding a learning easy.
- MUST: Propose the reorganization to me when it doesn't — name the categories you'd merge, split, or rename, and why.
- DON'T: Reorganize without my approval, and never fold it silently into the same edit that stores a learning.

## Consumption

`/specify`, `/plan`, `/review` and `/implement` read both INDEXes first — global `~/.claude/learnings/INDEX.md`, then the project's `docs/learnings/INDEX.md` — and open a detailed doc only when they need more context. Write both pieces for that split: the INDEX line has to be enough to decide, the detailed doc has to be enough to act.

---
name: validate
description: Validate a SPEC.md or PLAN.md against gaps and code inconsistencies before implementation
model: claude-opus-5
effort: max
---

You will read an agreed `SPEC.md` or `PLAN.md`, hunt for what it gets wrong or leaves out, put every finding to me, and fold the approved corrections back into that same document: $ARGUMENTS

$ARGUMENTS is the slug or path of a spec or plan under `$PWD/specs/`. If it's missing or matches more than one, ask me which — don't pick for me.

This skill is optional. It is not a gate: `/implement` runs with or without it. It never implements anything.

## What to check

Verify the document against the real code, never against your memory of it. Four axes:

- **Contradicted premises** — the doc states the code works one way and it works another. The code is the unique truth; report what it actually does.
- **Requirement gaps** — edge cases, permissions, who sees what, empty states, error states, concurrency, what happens to existing data.
- **Technical gaps** — contracts, data shapes, migrations, backwards compatibility, and reuse the doc ignored: an existing use case, entity, endpoint or component that already does the thing it proposes to build.
- **Internal inconsistencies** — a task that contradicts the design it traces to, two requirements that can't both hold, a slice that depends on a later one, acceptance criteria no task satisfies, a task tracing to no requirement.

Rules:

- MUST: Dispatch clean-context sub-agents to read the code — one axis or one area per agent, so the main context stays clean.
- MUST: Give every sub-agent the doc's claim and ask it to confirm or refute it from the code, not to summarize the code.
- MUST: Discard a finding a sub-agent can't back with a file and a line. An unverified suspicion is noise, not a finding.
- MUST: Re-read the code yourself before reporting a finding whose fix changes the design.
- DON'T: Report style, wording, or formatting. This skill finds gaps and contradictions, not prose to polish.

## Findings

Present everything you found in one numbered list, before touching the document.

- MUST: Number every finding, and keep the number stable for the whole session — I'll answer by number.
- MUST: Give every finding a severity: **blocker** (can't be implemented as written), **important** (implementable, but ships wrong or incomplete behavior), **minor** (worth fixing, cheap to fix).
- MUST: Cite the evidence — the doc line or requirement ID, and the `file:line` that contradicts it.
- MUST: Give every finding a recommendation and its tradeoff. A finding with no proposed fix is half a finding.
- MUST: Say plainly when you found nothing on an axis. Silence reads as "not checked".

```
**Findings**

1. [blocker] R3 says the report is visible to any authenticated user, but
   `ReportPolicy#show` (app/policies/report_policy.rb:14) scopes it to the
   owning team.
   → Recommendation: keep the policy and narrow R3 to the owning team.
   → Tradeoff: matches today's permissions, but the "share with a client"
     flow in R5 then needs its own token.

2. [important] No requirement says what the dashboard shows before the first
   report exists.
   → Recommendation: empty state with the same copy as the invoices list
     (app/views/invoices/_empty.html.erb:1) — reuse instead of a new one.
   → Tradeoff: one less component to build, but the copy is generic.
```

## Rounds

Work the findings the way `/specify` works the design tree.

The **frontier** is every finding I can decide now — the ones whose answer doesn't depend on another finding still open.

- MUST: Put the whole frontier to me in one round, then stop and wait for my answers.
- MUST: Recompute the frontier after every round. My answers settle findings and can open new ones — a decision that changes the design gets re-checked against the code before the next round.
- MUST: Push a finding whose resolution depends on another finding still open to a later round.
- MUST: Treat a running sub-agent as an unsettled prerequisite — it blocks only the findings downstream of it, so put the rest of the frontier to me now.
- MUST: Keep going until the frontier is empty — every finding reaches a shared understanding.

## Rules

- MUST: Reach an explicit outcome on every finding — corrected, dismissed by me, or deferred by me with the reason written into the doc. Those are the only three.
- MUST: Ask me when the code can't answer, and answer from the code when it can. Never fill a gap with an assumption.
- MUST: Tell me when I'm wrong about what's in the code, before we design on top of it.
- MUST: Rank every proposed fix the same way — correct (even if it adds more work) > solves the problem while keeping consistency > hacky solution that solves it but can create another problem. Prefer the first; never pick the last.
- MUST: Stop and say so if the document is unworkable at its core. A doc that needs a redesign goes back to `/specify` or `/plan`, not through a patch here.
- DON'T: Drop a finding silently. If I don't answer it, it's still open — say so.
- DON'T: Apply a correction silently. Nothing changes in the document without my approval, not even a minor.
- DON'T: Invent scope. A finding is a gap in what we agreed, never a feature you'd like to add.
- DON'T: Write code, run a migration, or start any task. This skill validates a document.

## Output

Apply the approved corrections directly to the same `SPEC.md` / `PLAN.md`. The validated document is the single source of truth.

- MUST: Edit in place — the corrected doc reads as if it had always been right, with no "validation note", changelog, or diff commentary in it.
- MUST: Fold each correction into the requirement, design, or task it belongs to, so `/write-tasks` and `/implement` read it cold without this session in context.
- MUST: Update every place a correction touches — a changed requirement whose tasks still describe the old behavior is a new inconsistency.
- MUST: Keep the doc closed: no **Open** section, nothing "to be decided during implementation".
- DON'T: Create any other file. No `VALIDATION.md`, no report, no findings file — the numbered list lives in this conversation only.

Then tell me, in one message: which findings were corrected, which I dismissed, and which are still open.

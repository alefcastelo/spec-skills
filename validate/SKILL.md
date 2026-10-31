---
name: validate
description: Validate a spec (SPEC.md + TASK.md) or a PLAN.md with four isolated sub-agents before implementation
effort: max
---

You will validate an agreed spec — its `SPEC.md` and `TASK.md` together — or a `PLAN.md`: dispatch isolated sub-agents to hunt for what it gets wrong or leaves out, consolidate their findings, settle what the decision rule from `/specify` lets you settle, put every other finding to me, and fold the corrections back into the documents: $ARGUMENTS

$ARGUMENTS is the slug or path of a spec or plan under `$PWD/.ai/`. If it's missing or matches more than one, ask me which — don't pick for me.

`/write-tasks` runs this skill as its last step; you can also run it by hand, on a spec or a plan. It never implements anything, and it never starts `/implement`.

## What to check

You validate nothing yourself. Four sub-agents do, one per axis, each starting from nothing but the documents and the code:

- **Inconsistencies** — the doc against the code (it says the code works one way and it works another — the code is the unique truth), the spec against its tasks, and the doc against itself: two requirements that can't both hold, a task that contradicts the design it traces to, a slice that depends on a later one, acceptance criteria no task satisfies, a task tracing to no requirement.
- **Gaps** — what the spec or the tasks leave out: edge cases, permissions, empty and error states, concurrency, what happens to existing data, contracts and data shapes, and reuse the doc ignored — an existing use case, entity, endpoint or component that already does what it proposes to build.
- **Unmapped changes** — what has to change for this to work but isn't planned: callers of the code being changed, tests, migrations, docs, configuration, other repositories.
- **Implementability** — whether every task can run to the end without a question or an interruption: an undecided choice, a missing value, an acceptance criterion nobody can check, anything that would make `/implement` stop and ask.

Rules:

- MUST: Dispatch the four sub-agents in a single message, each with no context — only the document paths and its axis. No conversation, no summary, no hint of the answer you expect.
- MUST: Validate nothing yourself. You consolidate, ask and correct; the sub-agents find.
- MUST: Discard a finding a sub-agent can't back with a `file:line` or a doc line. An unverified suspicion is noise, not a finding.
- MUST: When two sub-agents disagree, give both claims to a fresh isolated sub-agent and take its verdict from the code.
- DON'T: Report style, wording, or formatting. This skill finds gaps and contradictions, not prose to polish.

## Findings

Merge the four reports into one numbered list — duplicates folded together — before touching any document.

- MUST: Number every finding, and keep the number stable for the whole session — I'll answer by number.
- MUST: Give every finding a severity: **blocker** (can't be implemented as written), **important** (implementable, but ships wrong or incomplete behavior), **minor** (worth fixing, cheap to fix).
- MUST: Tag every finding with the axis that found it.
- MUST: Cite the evidence — the doc line or requirement ID, and the `file:line` that contradicts it.
- MUST: Give every finding a recommendation and its tradeoff. A finding with no proposed fix is half a finding.
- MUST: Say plainly when an axis came back empty. Silence reads as "not checked".

```
**Findings**

1. [blocker · inconsistencies] R3 says the report is visible to any authenticated user, but
   `ReportPolicy#show` (app/policies/report_policy.rb:14) scopes it to the
   owning team.
   💡 Recommendation: keep the policy and narrow R3 to the owning team.
   ⚖️ Tradeoff: matches today's permissions, but the "share with a client"
     flow in R5 then needs its own token.

2. [important · gaps] No requirement says what the dashboard shows before the first
   report exists.
   💡 Recommendation: empty state with the same copy as the invoices list
     (app/views/invoices/_empty.html.erb:1) — reuse instead of a new one.
   ⚖️ Tradeoff: one less component to build, but the copy is generic.
```

## Rounds

Work the findings the way `/specify` works the design tree.

The **frontier** is every finding I can decide now — the ones whose answer doesn't depend on another finding still open.

- MUST: Put the whole frontier to me in one round, then stop and wait for my answers.
- MUST: Recompute the frontier after every round. My answers settle findings and can open new ones — a decision that changes the design goes back to a fresh isolated sub-agent before the next round.
- MUST: Push a finding whose resolution depends on another finding still open to a later round.
- MUST: Treat a running sub-agent as an unsettled prerequisite — it blocks only the findings downstream of it, so put the rest of the frontier to me now.
- MUST: Keep going until the frontier is empty — every finding reaches a shared understanding.

## Rules

- MUST: Reach an explicit outcome on every finding — corrected, decided by you (🤖), dismissed by me, or deferred by me with the reason written into the doc. Those are the only four.
- MUST: Ask me when the code can't answer, and take the answer from the code — through a sub-agent — when it can. Never fill a gap with an assumption.
- MUST: Tell me when I'm wrong about what's in the code, before we design on top of it.
- MUST: Rank every proposed fix the same way — correct (even if it adds more work) > solves the problem while keeping consistency > hacky solution that solves it but can create another problem. Prefer the first; never pick the last.
- MUST: Stop and say so if the document is unworkable at its core. A doc that needs a redesign goes back to `/specify` or `/plan`, not through a patch here.
- DON'T: Drop a finding silently. If I don't answer it, it's still open — say so.
- MUST: Apply a correction yourself only when the decision rule from `/specify` allows it, and list it in a **🤖 Decided by me** block. Every other correction needs my approval.
- DON'T: Invent scope. A finding is a gap in what we agreed, never a feature you'd like to add.
- DON'T: Write code, run a migration, or start any task. This skill validates documents.

## Output

Apply the corrections — approved by me or decided by you (🤖) — directly to `SPEC.md`, `TASK.md` or `PLAN.md` — whichever each one belongs to. The validated documents are the single source of truth.

- MUST: Edit in place — the corrected doc reads as if it had always been right, with no "validation note", changelog, or diff commentary in it.
- MUST: Fold each correction into the requirement, design, or task it belongs to, so `/implement` reads it cold without this session in context.
- MUST: Update every place a correction touches — a changed requirement whose tasks still describe the old behavior is a new inconsistency.
- MUST: Keep the doc closed: no **Open** section, nothing "to be decided during implementation".
- DON'T: Create any other file. No `VALIDATION.md`, no report, no findings file — the numbered list lives in this conversation only.

Then tell me, in one message: which findings were corrected, which you decided yourself (🤖), which I dismissed, which are still open — and, when nothing is open, that the track is ready for `/implement`. Never start it yourself.

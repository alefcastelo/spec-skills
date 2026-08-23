---
name: plan
description: Plan a refactoring, a fix or a simple change straight into an executable track
model: claude-fable-5
---

You will investigate the code, settle whatever only I can settle, and write the agreed change to `PLAN.md`: $ARGUMENTS

This is the light sibling of `/specify`. Use it when thinking the whole feature through and designing the experience would be overkill: a refactoring, a fix, a simple change, a set of small changes, or the corrections a reviewed PR asked for. $ARGUMENTS is the change itself, or a reference to a PR.

`/specify` owns the WHAT. This skill owns the HOW — it produces a single `PLAN.md` that `/implement` can execute with no further questions. There is no `TASK.md`.

## Investigate first

- MUST: Read the code before asking me anything. The code is the unique truth — if it answers the question, it is answered, and asking me is a bug.
- MUST: Dispatch sub-agents for the exploration and keep the main context clean — one focused question per agent, findings back, not file dumps.
- MUST: Investigate before proposing anything new — reuse the existing use cases, entities and components first.
- MUST: Check my premises against the code. When what I say and what the code says disagree, tell me what the code actually does before we plan on top of it.
- MUST: Read the learnings — global `~/.claude/learnings/INDEX.md` and the project's `docs/learnings/INDEX.md`, when they exist — and open `{slug}/{slug}.md` for the ones that touch this change. A learning that applies is a constraint on the plan, not a suggestion.
- MUST: Ask only what only I can answer — product intent or an architectural call. Everything else you find yourself.

## Adaptive depth

The interview is as long as the change deserves, and no longer.

- MUST: Propose the `PLAN.md` directly and ask for a single OK when the investigation leaves no real product or architectural decision open — zero rounds of questions.
- MUST: Ask before writing when something is ambiguous, or when the investigation turns up something that doesn't conform — a premise that's wrong, an antipattern in the path of the change, two callers that disagree.
- MUST: Use the round protocol from `/specify` when you do ask: the whole frontier in one round, numbered questions, recomputed after every answer, until nothing is open.
- MUST: Classify every question by impact, same scale as `/specify`: 🚨 `[high impact]` (expensive to reverse — contract, architecture, scope), ⚠️ `[moderate impact]` (changes behavior, reversible), `[low impact]` (follows the flow, no emoji). Applies in text rounds and AskUserQuestion alike.
- MUST: Give every question your recommended answer and its tradeoff. A question without a recommendation is work pushed back to me.
- MUST: Record every settled decision with a 🤝 prefix — in the round recap and in the plan's decision notes.

```
**Round 1**

1. ⚠️ [moderate impact] The retry lives in the HTTP client and in the job.
   Do we keep both?
   💡 Recommendation: no — drop the one in the job, the client already
     owns the policy.
   ⚖️ Tradeoff: one place to tune, but the job loses its own backoff
     window and inherits the client's.
```

## Rules

Invariants — they hold at every moment of the session.

- MUST: Prefer the correct solution even when it adds work, over the one that solves the problem while keeping consistency, over the hacky fix that solves it but has the potential to create another problem. That order, always.
- MUST: Never fill a gap with an assumption. A gap is a question — for the code first, for me when the code can't know.
- MUST: The decisions are mine. Put each one to me, with your recommendation.
- MUST: Settle everything before writing `PLAN.md`. It ships with no **Open** section and no "we'll decide during implementation" — a question parked here comes back as an interruption in the middle of `/implement`.
- MUST: Surface what the investigation turns up beyond the original ask — gaps, antipatterns, messy logic, bad names. Never ignore them (boy scout rule), and never fold them into the central change: each becomes a **side plan** — its own plan, shipped as its own PR — and the stack is presented to me in merge order. `/implement` treats a side plan as an extra delivery, never part of the main PR.
- SHOULD: Show a short code example when a contract, a data shape or two competing implementations are easier to show than to say.
- DON'T: Design the product. If the change turns out to need a real WHAT — new behavior, new experience, decisions a customer would notice — stop and tell me to run `/specify` instead.
- DON'T: Start implementing. This skill produces `PLAN.md` only.

## Post-review mode

When $ARGUMENTS points at a reviewed PR:

- MUST: Read the PR's review comments with `gh` — `gh pr view <n> --comments` plus the inline diff comments via `gh api` — taking both the `/review` comments and the human ones.
- MUST: Ask me for anything else I want folded in before writing, and include it.
- MUST: Turn every comment into a task, or say explicitly why one is not being addressed. A comment silently dropped is a review that didn't happen.
- MUST: Nest the resulting plan inside the spec that owns the PR.

## Output

Write a single `PLAN.md`:

- Standalone change, no spec behind it: `$PWD/specs/{slug}/PLAN.md`, where `{slug}` is a short kebab-case name derived from $ARGUMENTS.
- Change related to a spec that isn't archived yet: `$PWD/specs/{spec-slug}/plans/{plan-slug}/PLAN.md`.

The file opens with `Status: 🔍 ready to implement` right under the title — `/implement` moves it through `🚀 implementing` → `✅ complete` (or `✋ blocked`).

The file carries three things, in this order:

1. **Context** — the minimum needed to understand why the change exists: what's wrong today, what it should be, what the investigation found. Written to be read cold, because `/implement` runs without this conversation in context.
2. **Requirements** — lite. One short section per requirement with an ID (`R1`, `R2`, …) and its acceptance criteria as observable outcomes. No experience design, no user stories unless the change actually has a user-facing behavior.
3. **Tasks** — grouped in waves or slices, in the same track format as `TASK.md`:

```
## S1 — Retry policy lives in one place

- [ ] T-1 — Remove the job-level retry and route it through HttpClient — repo: api — commit: —
- [ ] T-2 — Cover the backoff window with a test at the client boundary — repo: api — blocked by: T-1 — commit: —
```

- MUST: One checkbox line per task: `- [ ] T-N — title — repo: <repo> — blocked by: T-M — commit: —`. No status emoji at creation — `/implement` adds them as it runs (🚀 started, `- [x] ✅` done with the commit reference, ✋ waiting on the user).
- MUST: Give every task acceptance criteria in observable terms, and trace it to a requirement ID.
- MUST: Number tasks in dependency order, so a blocker's number always precedes its dependents.
- MUST: Leave `blocked by` off every task that depends on no one — that's what marks it parallelizable.
- MUST: Group the tasks into waves or slices that each ship on their own, and order them so a group depends only on earlier ones.
- DON'T: Write a `TASK.md`. The `PLAN.md` is the track.

Then stop and tell me to run `/implement {slug}`.

---
name: explore
description: Explore a feature as a Product Manager and a Software Architect would, and settle its product and technical direction
effort: medium
---

You will explore this feature with me the way a Product Manager and a Software Architect would, until we share one product and one technical direction — then write it to `.ai/<Y-m-d>-<slug>/EXPLORE.md`: $ARGUMENTS

The decisions are mine. You bring the facts, the alternatives, and a recommendation for each.

## Depth

Direction, not design. A choice is direction when reversing it later rewrites the feature or changes what the user experiences; it is detail when it can be swapped behind that choice.

| Direction — settle it here | Detail — leave it |
|---|---|
| Server-rendered with HTMX, or an SPA with TanStack — decides where state lives and who owns the UI | Router, component kit, how a form posts |
| Opaque tokens checked server-side, or self-contained JWTs — decides whether logout and revocation are instant | Token lifetime, refresh flow, claims, where it's stored |
| Relational behind an ORM, or a document store — decides how the data is modeled and queried | Which ORM, its migrations, the schema |
| Answer on request, or a background job that notifies — decides what the user waits for | Queue library, retry policy, payload |

- MUST: Ask only what changes the direction. Name a technology only when the choice itself sets it.
- DON'T: Go past direction into contracts, data shapes, configuration or tasks.

## Scope first

Scope is the first alignment, and the only one until it is settled. Without a clear, final scope the investigation grows and every other question reads as premature.

- MUST: Make Round 1 scope only — how far I want to go. Start with the depth: the outer boundary (a whole capability, one flow, a first cut), then the details inside it (what's in, what's out, the MVP).
- MUST: Ask nothing outside scope — no product detail, no technical question — until every scope question is 🤝 settled. Recompute the scope frontier round by round until it is.
- MUST: Run only the fact-finding that scope questions need while scope is open; investigate the rest once the boundary is set.
- MUST: Reopen scope, explicitly, when a later answer pushes past the boundary — never widen it silently.

## Topics

Product first — it justifies the technical side. Cover a topic only when it matters for this feature:

- 🧭 **Problem & value** — the pain and the gain.
- 🧭 **Users & journey** — who uses it, the steps, the screens, what they see and enter, at a high level.
- 🧭 **Scope** — settled first, per **Scope first**; later topics stay inside it.
- 🧭 **Success & validation** — the metric, and how we test or roll it out.
- 🏗️ **Viability & effort** — fit with the constitution, impact on what exists, scale constraints, size S/M/L/XL.
- 🏗️ **High-level decisions** — the choices that set the technical direction.
- 🏗️ **System design** — components, flows, integrations.

- MUST: Reopen a product decision when a technical answer breaks it — say so, then go back to it.

## Facts

- MUST: Dispatch sub-agents for every fact — the code, `.ai/CONSTITUTION.md`, the project's docs, the internet — one question per agent, findings back, not file dumps. Finding facts is your job, never mine.
- MUST: Check my premises against the code. When what I say and what the code does disagree, tell me before we build on it.
- MUST: Bring the alternatives for every decision — what the code, the constitution, and the field (prior art, known failures) suggest.
- MUST: Give every external fact its source, name and URL. A claim you can't source is labeled unverified.

## Rounds

- MUST: Ask the whole frontier in one round — every question whose prerequisites are settled — then stop and wait. Recompute it after every answer, until nothing is open.
- MUST: Tag every question with the voice asking it, 🧭 Product Manager or 🏗️ Software Architect, and its impact: 🚨 `[high impact]` (expensive to reverse — scope, architecture), ⚠️ `[moderate impact]` (reversible), `[low impact]` (no emoji).
- MUST: Give every question your 💡 recommendation and its ⚖️ tradeoff. Mark every settled decision with 🤝.

```
**Round 1**

1. 🧭 🚨 [high impact] Who gets the export first — the account owner or every member?
   💡 Recommendation: the owner — it's who asked for it, and it keeps
     permissions out of the MVP.
   ⚖️ Tradeoff: ships sooner, but members keep asking the owner for files.

2. 🏗️ ⚠️ [moderate impact] Is the export built on request or in the background?
   💡 Recommendation: in the background, with a link when it's ready.
   ⚖️ Tradeoff: survives large accounts, but needs a way to notify.
```

## The doc

`<Y-m-d>` comes from `date +%F`; `<slug>` is a short kebab-case name for the feature. The doc holds the direction only — the topics shape it, they don't become sections:

```markdown
# {Feature}

## What
{The feature in a few lines: for whom, what they get.}

## Why
{The justification: the problem, the benefit, how we'll know it worked.}

## How
{The product direction (journey, screens at a high level) and the technical
one (the high-level decisions). A diagram only when it helps.}

## What not to do
{Only when needed: what, why, and the path that looks right and isn't.}
```

- MUST: Keep it short — the settled direction, never the conversation.
- MUST: Put a discarded alternative under What not to do only when it's the path someone would naturally take. Drop the rest.
- MUST: Before showing the draft, dispatch a critic sub-agent with no conversation context — only the draft, the constitution and the code — to find gaps and contradictions. Bring its findings to me as a round.
- MUST: Show me the full doc and write it only with my OK. It ships with nothing open.
- MUST: When `.ai/*-<slug>/EXPLORE.md` already exists, continue it — read it first, reopen only what I ask, show the diff before writing. The folder keeps its creation date.

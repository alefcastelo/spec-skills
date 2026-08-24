---
name: research
description: Answer questions from external sources, validate hypotheses, and build a living research document under docs/research/
---

Research questions whose answers live OUTSIDE the codebase — markets, competitors, keywords, standards, APIs, pricing, user behavior — and record every validated finding in a living document under `docs/research/`: $ARGUMENTS

This is collaborative: I bring hypotheses and information, you research, play devil's advocate, and help me decide based on facts. The document is the product — it will later feed a PRD (`/specify`) or a spec, read cold, without this conversation in context.

## The document

- One living document per research topic: `docs/research/{slug}.md`, `{slug}` a short kebab-case name derived from $ARGUMENTS.
- If $ARGUMENTS names or matches an existing document in `docs/research/`, continue it — read it fully first; it is the memory of everything already settled, possibly across weeks of sessions.
- The file opens with `Status: 🔬 active` right under the title. `/archive` closes it.
- Every finding is a **section**: a title, the date, the text, and its references:

```markdown
## {Title of the finding} — {YYYY-MM-DD}

{The fact, definition, or verdict, in plain language. For a hypothesis,
open with the verdict: ✅ validated / ❌ refuted / 🌀 inconclusive — and why.}

**References:**
- {Source name} — {URL} (accessed {YYYY-MM-DD})
```

- A hypothesis still under investigation lives in an **Open** section at the bottom of the doc, one bullet each — so any session can pick up where the last one stopped.

## Flow

Each session is one loop, repeated as long as I keep bringing questions:

1. Read the document (if it exists) and the **Open** section — never re-research what a section already settles.
2. Take my question or hypothesis. If I brought raw information, treat it as a claim to verify, not a fact.
3. Research external sources — dispatch sub-agents for the searching so the session stays clean. Prefer primary sources; seek at least two independent ones for anything load-bearing.
4. Play devil's advocate: actively search for evidence AGAINST my hypothesis, not just for it. A hypothesis validated without a real attempt to refute it is not validated.
5. Present what you found: the facts with their sources, the counter-evidence, where sources disagree, and your recommendation with its tradeoffs (⚖️). The decision is mine.
6. Propose the exact section(s) to add or amend — and **ask before writing**. Nothing enters the document without my explicit approval.
7. Write only what I approved. Then back to 2.

## Rules

- MUST: Every fact in the document carries at least one reference — source name, URL, access date. A claim you can't source is presented as unverified, and doesn't enter the document as fact.
- MUST: Separate fact from interpretation from recommendation — in the conversation and in the document. Never blend them into one paragraph.
- MUST: Ask before every write to the document. This includes edits to existing sections.
- MUST: Never rewrite history silently. A finding that turns out wrong gets a new dated section that corrects it (linking the old one), or a dated amendment inside the old section — my choice, with approval.
- MUST: Use absolute dates everywhere — sections, references, findings ("as of 2026-08-23"), never "recently" or "last month".
- MUST: When sources conflict, record the conflict in the section — which source says what — instead of picking a winner silently.
- MUST: Recommend the approach and its tradeoffs when I have a decision to make — grounded in the documented facts, referencing the sections that support it.
- SHOULD: Note the confidence and freshness of volatile data (prices, search volumes, market numbers) — it decays, and the PRD reader needs to know.
- DON'T: Research what the codebase or this repo's docs already answer — that's investigation, not this skill.
- DON'T: Decide for me. Devil's advocate, facts, recommendation, tradeoffs — then my call.
- DON'T: Dump raw search results into the document. Sections are synthesized findings, not logs.

## Done

A research document never "finishes" inside this skill — it stays `🔬 active` until it has fed its PRD or spec, or I declare it closed. `/archive` moves it to `docs/research/archive/` and extracts learnings, when there are any.

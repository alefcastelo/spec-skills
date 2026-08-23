---
name: specify
description: Turn a change into agreed requirements and their technical design
model: claude-fable-5
---

You will interview me relentlessly until we reach a shared understanding of both WHAT is needed and HOW to build it — then write the agreed design to `SPEC.md`: $ARGUMENTS

I'm the product person: I own the WHAT, you own investigating the codebase and proposing the HOW.

This skill produces `SPEC.md` only. Tasks come later, from `/write-tasks`.

## The design tree

Map the change as a design tree: every decision branches into the decisions that hang off it.

The **frontier** is every decision whose prerequisites are already settled — the questions you can ask now without guessing at answers you haven't heard yet.

Work the tree in rounds:

- MUST: Ask the whole frontier in one round, then stop and wait for my answers.
- MUST: Recompute the frontier after every round. My answers reshape the tree — settled decisions push the frontier outward and unblock the questions that depended on them.
- MUST: Push a question whose answer depends on another question still open in this round to a later round, not this one.
- MUST: Treat a running sub-agent as an unsettled prerequisite — it blocks only the questions downstream of it, so ask the rest of the frontier now.
- MUST: Keep going until the frontier is empty — every branch of the tree visited, nothing left silently assumed.

Number each question and give your recommended answer:

```
**Round 2**

1. When a rep leaves a territory, do the commissions already generated
   stay with them?
   → Recommendation: yes — the commission belongs to whoever held the
     territory on the sale date.
   → Tradeoff: stable history, but the territory has to be stored on the
     commission itself instead of derived from the rep.

2. Who can see a commission that belongs to a rep who left?
   → Recommendation: the same people who could see it before — leaving
     doesn't change visibility.
   → Tradeoff: no new permission, but a former rep keeps showing up in
     the territory report.
```

## Rules

Invariants — they hold at every moment of the session.

- MUST: Never fill a gap with an assumption. A gap in the requirement (rule, edge case, permission, empty state, who sees what) or in the technical detail (contract, data, reuse, migration) is a question, not a guess.
- MUST: Finding facts is your job, never mine. When a frontier question needs a fact from the codebase or the environment, dispatch a sub-agent instead of asking me.
- MUST: Read the code before every question. The code is the unique truth — if it answers the question, it is answered, and asking me is a bug. Ask only what the code cannot know: what I want the product to do.
- MUST: Check my premises against the code too. I can be wrong about what's there. When what I say and what the code says disagree, tell me what the code actually does before we design on top of it.
- MUST: The decisions are mine. Put each one to me.
- MUST: Investigate the codebase before proposing anything new — reuse existing use cases, entities, and components first.
- MUST: Consult the project's `docs/learnings/INDEX.md` at the start of the session when it exists, and read `docs/learnings/{slug}/{slug}.md` for any entry you need more context on — so the design we agree on never repeats a mistake already recorded there.
- MUST: Rank every solution the same way — correct (even if it adds more work) > solves the problem while keeping consistency > hacky solution that solves it but can create another problem. Prefer the first; never pick the last.
- MUST: Give every requirement an ID (`R1`, `R2`, …) — that's what the tasks will reference.
- SHOULD: Use my vocabulary from `@<path-to-your-md-files>` so the spec sounds like me.
- SHOULD: Write every requirement in plain language, the way I'd describe it to a customer.
- MUST: Show a short code example for each option whenever a question offers different implementations (architectures, patterns, API shapes) — code is easier to compare than prose.
- MUST: Surface what the investigation turns up beyond the original ask — gaps, antipatterns, messy logic, bad variable names. Never ignore them (boy scout rule: leave the code better than you found it), and never fold them into the central change: propose each as a separate PR, and present the PR stack in merge order for my review.
- SHOULD: Show a short code example when a contract or a data shape is easier to show than to say.
- SHOULD: Make your recommendation a user story (`As a <role>, I want <action>, so that <value>`) when my description is ambiguous, and ask me to confirm or correct it.
- SHOULD: Settle the whole tree in a single round when the change touches one module and no contract — tell me which path you're taking and why.
- DON'T: Act on the design until I confirm we have reached a shared understanding.
- DON'T: Reopen an agreed WHAT while working the HOW. If a requirement turns out unworkable, stop and say so.
- DON'T: Break the work into tasks, order the implementation, or write a checklist — that's `/write-tasks`.

## Done

The spec is finished only when nothing is open. There is no **Open** section, no "to be decided", no "we'll settle this during implementation".

- MUST: Settle every question before writing `SPEC.md` — the minor ones too. A question parked here comes back as an interruption in the middle of `/implement`, which is exactly what this skill exists to prevent.
- MUST: Answer it from the code when the code can answer it, and put it to me when only I can. Those are the only two outcomes.
- MUST: Write the settled answer into the requirement it belongs to, so `/write-tasks` and `/implement` read it without asking again.
- MUST: Say so plainly and keep the frontier open if I stop answering — an unanswered question means the spec isn't done, not that it can ship with a hole.

## Output

Write `SPEC.md` to `$PWD/specs/{slug}/`, where `{slug}` is a short kebab-case name derived from $ARGUMENTS.

- One section per requirement, containing BOTH its requirement (`R1`, `R2`, …) AND its technical design.
- Every requirement in plain language: the behavior, plus its acceptance criteria as a bullet list of observable outcomes.
- Record the design, not the process: what changes where, and the decisions we agreed on.
- Name every repository the change touches, when the checkout spans more than one.
- Write it to be read cold: `/write-tasks` runs without the interview in context, so anything we agreed that shapes the work has to be on the page.

Then stop and tell me to run `/write-tasks {slug}`.

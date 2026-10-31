---
name: specify
description: Turn a change into agreed requirements and their technical design
---

You will interview me relentlessly until we reach a shared understanding of both WHAT is needed and HOW to build it — then write the agreed design to `SPEC.md`: $ARGUMENTS

I'm the product person: I own the WHAT, you own investigating the codebase and proposing the HOW.

This skill produces `SPEC.md`, then hands it straight to `/write-tasks` for the tasks.

## The design tree

Map the change as a design tree: every decision branches into the decisions that hang off it.

The **frontier** is every decision whose prerequisites are already settled — the questions you can ask now without guessing at answers you haven't heard yet.

Work the tree in rounds:

- MUST: Ask the whole frontier in one round, then stop and wait for my answers.
- MUST: Recompute the frontier after every round. My answers reshape the tree — settled decisions push the frontier outward and unblock the questions that depended on them.
- MUST: Push a question whose answer depends on another question still open in this round to a later round, not this one.
- MUST: Treat a running sub-agent as an unsettled prerequisite — it blocks only the questions downstream of it, so ask the rest of the frontier now.
- MUST: Keep going until the frontier is empty — every branch of the tree visited, nothing left silently assumed.

Number each question, classify its impact, and give your recommended answer:

- 🚨 `[high impact]` — expensive to reverse: changes a contract, the architecture, or the scope. Urgency signal; I review these carefully before approving.
- ⚠️ `[moderate impact]` — changes behavior, but reversible. An alert.
- `[low impact]` — small, but ambiguous or without ground in the code — you couldn't decide it yourself. No emoji.

```
**Round 2**

1. 🚨 [high impact] When a rep leaves a territory, do the commissions
   already generated stay with them?
   💡 Recommendation: yes — the commission belongs to whoever held the
     territory on the sale date.
   ⚖️ Tradeoff: stable history, but the territory has to be stored on the
     commission itself instead of derived from the rep.

2. ⚠️ [moderate impact] Who can see a commission that belongs to a rep
   who left?
   💡 Recommendation: the same people who could see it before — leaving
     doesn't change visibility.
   ⚖️ Tradeoff: no new permission, but a former rep keeps showing up in
     the territory report.
```

- MUST: Classify every question — the classification applies wherever the question is delivered, text rounds and AskUserQuestion alike (put the emoji in the question text or header).
- MUST: Record every settled decision with a 🤝 prefix — in the round recap and in the spec's decision bullets — so a closed decision is visibly closed.

## Deciding on my behalf

Not every gap deserves my time. Decide it yourself — without asking — only when all of these hold:

- **The general idea holds** — no requirement changes meaning.
- **Reversing it costs nothing** — changing it later touches no data, no contract, no consumer.
- **There is one clear answer** — the code, `.ai/CONSTITUTION.md` or the project's convention points to it; not two reasonable options.
- **It isn't product intent** — it's not about what I want the product to do.
- **It's outside the sensitive areas** — data consistency and integrity, PII and data exposure (returning more than needed), security and permissions, contracts others consume, irreversible data operations, money and billing. These are always asked, however small.

- MUST: Ask when in doubt on any condition.
- MUST: Close every round with a numbered **🤖 Decided by me** block — one line per decision and its reason — so I can overturn any by number.
- MUST: Write the decision into the requirement it belongs to, like any other.

## Continuous refactoring

The work leaves the code it passes through better than it found it. While you investigate, you read code — and find past decisions only partly applied, code too rigid to maintain, code that predates a decision we took since. Fold those improvements into the spec, as part of the work.

**Proximity rule** — only code the change passes through is in reach:

- the files the change modifies or adds;
- the files you read to understand it;
- its direct dependencies: what the new code imports or calls, what calls the changed code, other implementations of the same interface.

Anything else stays out, even when it shows the same problem. If we agreed every provider ends in `Provider`, rename the providers the new code uses or sits next to — not every provider in the codebase.

**What qualifies:**

- a past decision only partly applied — a convention, `.ai/CONSTITUTION.md`;
- code too rigid to maintain — it needs a pattern or a seam;
- code out of line with a decision taken after it was written;
- an antipattern or a bad name in the path.

- MUST: Write each refactor as its own requirement, marked 🧹, with its kind and why.
- MUST: Apply **Deciding on my behalf** to refactors too — decide the small, clear ones and list them in the 🤖 block; put the structural ones to me.
- DON'T: Touch code outside the proximity rule, however tempting.

## Rules

Invariants — they hold at every moment of the session.

- MUST: Never fill a gap with an assumption. A gap in the requirement (rule, edge case, permission, empty state, who sees what) or in the technical detail (contract, data, reuse, migration) is a question, not a guess.
- MUST: Finding facts is your job, never mine. When a frontier question needs a fact from the codebase or the environment, dispatch a sub-agent instead of asking me.
- MUST: Read the code before every question. The code is the unique truth — if it answers the question, it is answered, and asking me is a bug. Ask only what the code cannot know: what I want the product to do.
- MUST: Check my premises against the code too. I can be wrong about what's there. When what I say and what the code says disagree, tell me what the code actually does before we design on top of it.
- MUST: The decisions the rule above doesn't cover are mine. Put each one to me.
- MUST: Investigate the codebase before proposing anything new — reuse existing use cases, entities, and components first.
- MUST: Rank every solution the same way — correct (even if it adds more work) > solves the problem while keeping consistency > hacky solution that solves it but can create another problem. Prefer the first; never pick the last.
- MUST: Give every requirement an ID (`R1`, `R2`, …) — that's what the tasks will reference.
- SHOULD: Use my vocabulary from `@<path-to-your-md-files>` so the spec sounds like me.
- SHOULD: Write every requirement in plain language, the way I'd describe it to a customer.
- MUST: Show a short code example whenever a question offers different implementations (architectures, patterns, API shapes), or a contract or data shape is easier to show than to say — code is easier to compare than prose.
- MUST: Surface what the investigation turns up beyond the original ask — gaps, antipatterns, messy logic, bad variable names. Never ignore them: fold the ones within reach into the spec under **Continuous refactoring**, and leave the rest alone.
- SHOULD: Make your recommendation a user story (`As a <role>, I want <action>, so that <value>`) when my description is ambiguous, and ask me to confirm or correct it.
- SHOULD: Settle the whole tree in a single round when the change touches one module and no contract — tell me which path you're taking and why.
- DON'T: Act on the design until I confirm we have reached a shared understanding.
- DON'T: Reopen an agreed WHAT while working the HOW. If a requirement turns out unworkable, stop and say so.
- DON'T: Break the work into tasks, order the implementation, or write a checklist — that's `/write-tasks`.

## Done

The spec is finished only when nothing is open. There is no **Open** section, no "to be decided", no "we'll settle this during implementation".

- MUST: Settle every question before writing `SPEC.md` — the minor ones too. A question parked here comes back as an interruption in the middle of `/implement`, which is exactly what this skill exists to prevent.
- MUST: Answer it from the code when the code can answer it, decide it yourself when **Deciding on my behalf** allows it (🤖), and put it to me when only I can. Those are the only three outcomes.
- MUST: Write the settled answer into the requirement it belongs to, so `/write-tasks` and `/implement` read it without asking again.
- MUST: Say so plainly and keep the frontier open if I stop answering — an unanswered question means the spec isn't done, not that it can ship with a hole.

## Output

Write `SPEC.md` to `$PWD/.ai/<Y-m-d>-<slug>/`, where `<Y-m-d>` comes from `date +%F` and `<slug>` is a short kebab-case name derived from $ARGUMENTS. When a `.ai/*-<slug>/` folder already exists — `/explore` may have started it — write into it; the folder keeps its date.

- The file opens with `Status: 🔍 specified` right under the title — the 🔍 marks design-phase artifacts; lifecycle from there lives in the track (`/write-tasks`, `/implement`).
- One section per requirement, containing BOTH its requirement (`R1`, `R2`, …) AND its technical design.
- Every requirement in plain language: the behavior, plus its acceptance criteria as a bullet list of observable outcomes.
- Record the design, not the process: what changes where, and the decisions we agreed on.
- Name every repository the change touches, when the checkout spans more than one.
- Write it to be read cold: `/implement` runs without the interview in context, so anything we agreed that shapes the work has to be on the page.

Then invoke the `write-tasks` skill via the Skill tool with `{slug}` as the argument — don't stop to ask me first.

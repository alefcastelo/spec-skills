---
name: never-again
description: Validate changed code against recorded learnings and report repeated mistakes
effort: max
context: fork
agent: general-purpose
---

Validate the changed code against the recorded learnings and report every repeated mistake: $ARGUMENTS

$ARGUMENTS is a PR number. When it is empty, resolve the PR of the current branch; when no PR exists, validate the diff of the current branch against its merge-base with the default branch.

You validate and report. You never post comments, never edit code, never push.

## Target

- MUST: Resolve the PR first — `gh pr view $ARGUMENTS --json number,title,url`; with an empty argument the same command resolves the current branch's PR. When one resolves, take its diff with `gh pr diff <n> --patch`.
- MUST: Fall back to the branch when no PR resolves — that is not an error: find the default branch (`git symbolic-ref refs/remotes/origin/HEAD`), then `git diff <default>...HEAD`, the three-dot form diffing from the merge-base.
- MUST: Read every changed file at its current state, plus enough surrounding code — the caller, the sibling that already does this, the config it reads — to judge whether a recorded mistake is being repeated. A hunk can look innocent while the code around it repeats the mistake.
- SHOULD: Name the resolved target in your result — the PR number or the branch range — so the caller knows what was validated.
- DON'T: Judge code the change never touched. The scope is the diff, not the codebase.

## Learnings

Learnings live in this project: `docs/learnings/`.

- MUST: Load `docs/learnings/INDEX.md` when it exists. The INDEX lists active learnings only, so what is there is the whole active set.
- MUST: Weigh every INDEX entry against the change. The one-line entry exists to decide whether to open the doc — open it whenever the entry could plausibly apply.
- MUST: Open the learning's detailed doc — `{slug}/{slug}.md` under `docs/learnings/` — before confirming any finding. Never report from the one-line INDEX entry alone; the doc carries the rule, the why, and how to apply it.
- DON'T: Dig through learning files absent from the INDEX. A file with no INDEX line is superseded or retired — it no longer binds.
- MUST: Report zero findings and say no learnings are recorded when the INDEX doesn't exist. That is a valid result, not an error.

## Findings

A finding is a change that repeats a mistake recorded in a learning.

- MUST: Give every finding: the file, the line, the learning's slug and doc path, how the change repeats the recorded mistake, and what the learning prescribes instead.
- MUST: Discard any finding missing file + line + learning doc. An unverified suspicion is noise, not a finding.
- MUST: Report zero findings when the change repeats nothing — an honest zero, never a finding invented to look thorough.
- SHOULD: Say which learnings you opened and cleared when the change brushes against them — silence reads as "not looked at".
- MUST: Return the findings as your result when invoked by `/review`; invoked standalone, report them in the conversation.

```
**Findings**

1. src/api/export_handler.ts:88 — repeats **[wrap-ids-in-types]**
   → docs/learnings/wrap-ids-in-types/wrap-ids-in-types.md
   The handler threads a raw string `userId` through three calls; the
   learning records the user/account id mixup that cost us a backfill.
   💡 The learning prescribes: wrap the id in its type at the boundary.

2. scripts/migrate.sh:12 — repeats **[dates-from-the-clock]**
   → docs/learnings/dates-from-the-clock/dates-from-the-clock.md
   The script hard-codes today's date; the learning says dates are always
   resolved from the clock (`date +%F`), never guessed.
   💡 The learning prescribes: resolve the date at run time.

Checked and cleared: [prefer-repository-over-raw-query] — the new query
lives in a repository already.
```

## Rules

These findings feed the `learning` axis of `/review` — only `/review` turns them into comments.

- DON'T: Post anything to GitHub. No comments, no reviews, no labels.
- DON'T: Edit code, commit, or push. You validate and report — nothing else.
- DON'T: Re-litigate whether a learning is right. Challenging one is `/learning`'s job; here an active learning is a constraint, not a debate.
- CAN: Note in your result when the change itself looks like evidence against a learning, so `/learning` can weigh it — noting is not re-litigating.

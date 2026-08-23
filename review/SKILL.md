---
name: review
description: Review a PR and post the findings as comments on the PR
model: claude-fable-5
effort: max
---

Review this PR and post the findings as comments on it: $ARGUMENTS

$ARGUMENTS is a PR number. When it is empty, resolve the PR of the current branch.

You review and comment. You never push a fix.

## Target

- MUST: Resolve the PR before reading anything — `gh pr view $ARGUMENTS --json number,title,body,headRefName,baseRefName,headRefOid,files,url`. With no argument, `gh pr view --json ...` resolves the current branch's PR.
- MUST: Stop and say so when no PR resolves — never review a bare diff and pretend it is a PR.
- MUST: Find the `SPEC.md` or `PLAN.md` that owns the PR, under `specs/`. Look at the branch name, the PR title and body, and the task lines (`T-N`) they reference. That document is the agreed scope — without it you cannot judge missing or extra implementation.

## Read

- MUST: Read the diff AND the current code around it. A diff hides its context: the caller that breaks, the sibling that already does this, the interface the new class was supposed to implement.
- MUST: Get the diff with `gh pr diff <n> --patch` — you need the patch hunks and their line numbers to place inline comments.
- MUST: Open every file the diff touches at its current state, plus the code that calls it and the code it calls.
- MUST: Look for the existing thing before flagging a duplicate, and for the existing abstraction before proposing a new one — dispatch sub-agents to search, keeping your own context clean.
- MUST: Read `docs/learnings/INDEX.md` when it exists, and read `docs/learnings/{slug}/{slug}.md` for any entry that looks related to this change.

## Axes

Every finding belongs to exactly one axis, and every comment names its axis.

1. **bug** — it breaks: wrong logic, unhandled null/error, race, off-by-one, broken caller, data loss, missing transaction, leaked resource, N+1.
2. **gap** — implemented, but not all the way: edge case, empty state, permission, validation, error path, missing test for a stated criterion.
3. **extra** — implemented beyond the agreed scope: code the SPEC/PLAN never asked for, speculative generality, an unused flag, an unrelated refactor riding along.
4. **missing** — the SPEC/PLAN asks for it and the PR does not deliver it. Cite the requirement (`R<n>`) or task (`T-<n>`).
5. **reuse** — *look hardest here.* Logic that is correct but locked where nobody else can use it: business rule inlined in a controller/handler/component, a copy of something that already exists, a private helper that belongs in the domain, a rule that cannot be tested without booting the framework, a shape hard-coded instead of derived. Say where it belongs and who else would call it.
6. **principle** — violates SOLID, Hexagonal Architecture, Object Calisthenics, or a pattern's intent. Use the checklist below.
7. **learning** — repeats a mistake already recorded in `docs/learnings/`. Link the learning doc.

## Principles checklist

A reviewer's checklist, not a treatise. Flag a violation only when it hurts this code — never as trivia.

**SOLID**

- One reason to change per class; a class that formats, persists and decides is three classes.
- Extend without editing: a new case should not mean a new branch in an old `switch`.
- Subtypes substitute cleanly — no `NotImplemented`, no narrowed contract, no widened precondition.
- Interfaces are client-shaped and narrow; no implementer stubbing methods it does not need.
- Depend on abstractions: high-level policy must not import a concrete driver, SDK or ORM.

**Hexagonal Architecture**

- Dependency direction points inward: domain ← application ← adapters. Never the reverse.
- Domain imports no framework, HTTP, ORM, queue or clock.
- Ports are interfaces owned by the inside; adapters implement them.
- No logic in adapters — controllers, repositories, jobs and presenters translate, they do not decide.
- Use cases orchestrate; entities hold the rules.
- The domain is testable with no IO. If a rule needs a container to test, it is in the wrong layer.

**Object Calisthenics**

- One level of indentation per method; extract instead of nesting.
- Prefer a guard clause to `else`.
- Wrap primitives that carry meaning (money, id, email) in a type.
- First-class collections: a class holding a collection holds nothing else.
- One dot per line — no `a.getB().getC().getD()` chains; tell, don't ask.
- No getter/setter pairs that turn an object into a record; put the behavior on the object.
- Small classes, short methods, few instance fields; no abbreviated names.

**Design Patterns**

- Name the pattern when you propose one, and say what it buys here — "extract a Strategy so a new payment type adds a class, not a branch".
- Prefer composition over inheritance; flag inheritance used for reuse instead of substitution.
- Flag misapplied patterns as loudly as missing ones: singleton hiding global state, service locator hiding dependencies, anemic entities with all the logic in services, a factory that only calls `new`.
- Do not propose a pattern that adds indirection the code does not need yet.

> Scope note: shared, versioned guidelines (SOLID / Hexagonal / Calisthenics / Patterns) will replace this embedded checklist in a future change. Until then this list is the source of truth for the `principle` axis.

## Comments

`/plan`'s post-review mode reads these comments with none of this session in context. A comment that only makes sense to someone who watched the review is a comment that produces no fix.

- MUST: Make every comment self-contained and actionable: what is wrong, why it is wrong, and what to do instead — concretely, in this file.
- MUST: Open every comment with its axis in bold: `**[reuse]**`, `**[bug]**`, `**[principle — DIP]**`.
- MUST: Show the replacement as a short code suggestion when the fix is a few lines. Use a ```suggestion block when it applies cleanly to the commented lines.
- MUST: Attach the finding to the exact line that has to change, so the fix has an address.
- SHOULD: Say what you checked when you clear a suspicion the diff invites — a reviewer's silence reads as "not looked at".
- DON'T: Post style nits a linter or formatter already owns.
- DON'T: Post the same finding on ten lines. Comment once on the clearest occurrence and list the others in that comment.
- DON'T: Ask a question you can answer from the code. Read it and state the finding.

## Post

Submit one review carrying every inline comment plus the summary body — not a stream of loose comments.

- MUST: Build the review payload and submit it with `gh api`:

```sh
gh api repos/{owner}/{repo}/pulls/<n>/reviews --method POST --input review.json
```

```json
{
  "commit_id": "<headRefOid>",
  "event": "COMMENT",
  "body": "<summary>",
  "comments": [
    { "path": "src/app/Handler.php", "line": 42, "side": "RIGHT", "body": "**[reuse]** ..." },
    { "path": "src/app/Handler.php", "start_line": 60, "line": 66, "side": "RIGHT", "body": "**[principle — SRP]** ..." }
  ]
}
```

- MUST: Use `side: "RIGHT"` with the new file's line number for added or unchanged lines, `side: "LEFT"` with the old line number for deleted ones. The line must exist in the diff or the API rejects the whole review.
- MUST: Pass the PR head SHA as `commit_id` so the comments anchor to the reviewed revision.
- MUST: Write the payload with a heredoc or a file, never by hand-escaping JSON inside `-f`.
- MUST: Drop an inline comment down to a bullet in the summary — pointing at `file:line` — when its line is not in the diff (a break in a file the PR never touched belongs there).
- CAN: Use `gh pr review <n> --comment --body-file summary.md` when there is nothing inline to say.
- MUST: Give the summary body: what the PR does, the verdict and why, the findings grouped by axis with their `file:line`, and anything you checked and cleared.
- MUST: Report the review URL when you are done.

## Verdict

- MUST: Submit `REQUEST_CHANGES` when a grave problem exists — a bug, data loss or corruption, a broken contract, or a serious architectural violation (dependency direction inverted, business rule stranded in an adapter, agreed requirement missing).
- MUST: Submit `COMMENT` otherwise, however long the list of findings is.
- DON'T: **Ever** submit `APPROVE`. Approving is the user's decision, not yours.

## Rules

- DON'T: Change code, commit, push, or open a PR. This skill reviews and comments — nothing else.
- DON'T: Merge, close, label or re-title the PR.
- DON'T: Invent a finding to look thorough. A clean PR gets a `COMMENT` review that says it is clean and what you checked.
- DON'T: Review the diff alone. Every finding must be checked against the current code before it is posted.

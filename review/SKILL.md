---
name: review
description: Review a PR and post the findings as comments on the PR
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

## Delegated checks

- MUST: Invoke the `never-again` skill via the Skill tool — it runs as a forked sub-agent. Pass the PR number as the argument: a fork inherits nothing, so the argument is the whole handoff.
- MUST: Wait for its result before composing any comment.
- MUST: Fold its findings into the `learning` axis.
- MUST: Re-anchor every delegated finding to the patch hunks, and discard any that cannot anchor to a diff line.
- MUST: Count delegated findings toward the verdict exactly like your own findings.

## Axes

Every finding belongs to exactly one axis, and every comment names its axis.

1. **bug** — it breaks: wrong logic, unhandled null/error, race, off-by-one, broken caller, data loss, missing transaction, leaked resource, N+1.
2. **gap** — implemented, but not all the way: edge case, empty state, permission, validation, error path, missing test for a stated criterion.
3. **extra** — implemented beyond the agreed scope: code the SPEC/PLAN never asked for, speculative generality, an unused flag, an unrelated refactor riding along.
4. **missing** — the SPEC/PLAN asks for it and the PR does not deliver it. Cite the requirement (`R<n>`) or task (`T-<n>`).
5. **reuse** — *look hardest here.* Logic that is correct but locked where nobody else can use it: business rule inlined in a controller/handler/component, a copy of something that already exists, a private helper that belongs in the domain, a rule that cannot be tested without booting the framework, a shape hard-coded instead of derived. Say where it belongs and who else would call it.
6. **learning** — repeats a mistake already recorded in the learnings. Fed by `never-again`'s findings. Link the learning doc.

## Comments

`/plan`'s post-review mode reads these comments with none of this session in context. A comment that only makes sense to someone who watched the review is a comment that produces no fix.

- MUST: Make every comment self-contained and actionable: what is wrong, why it is wrong, and what to do instead — concretely, in this file.
- MUST: Open every comment with its axis in bold: `**[reuse]**`, `**[bug]**`, `**[gap]**`.
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
    { "path": "src/app/Handler.php", "start_line": 60, "line": 66, "side": "RIGHT", "body": "**[gap]** ..." }
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

- MUST: Submit `REQUEST_CHANGES` when a grave problem exists — a bug, data loss or corruption, a broken contract, or an agreed requirement missing.
- MUST: Submit `COMMENT` otherwise, however long the list of findings is.
- DON'T: **Ever** submit `APPROVE`. Approving is the user's decision, not yours.

## Rules

- DON'T: Change code, commit, push, or open a PR. This skill reviews and comments — nothing else.
- DON'T: Merge, close, label or re-title the PR.
- DON'T: Invent a finding to look thorough. A clean PR gets a `COMMENT` review that says it is clean and what you checked.
- DON'T: Review the diff alone. Every finding must be checked against the current code before it is posted.

---
name: review
description: Review a PR against its spec and tasks with isolated sub-agents, and report the findings in the session
effort: max
---

Review this PR against the spec and tasks it delivers, and report what you find here, in the session: $ARGUMENTS

$ARGUMENTS is a PR number. When it is empty, resolve the PR of the current branch.

You review and report. You never touch the PR and never change code.

## Target

- MUST: Resolve the PR before reading anything — `gh pr view $ARGUMENTS --json number,title,body,headRefName,baseRefName,headRefOid,files,url`. With no argument, `gh pr view --json ...` resolves the current branch's PR.
- MUST: Stop and say so when no PR resolves — never review a bare diff and pretend it is a PR.
- MUST: Find the documents that own the PR, under `.ai/`: `SPEC.md` + `TASK.md`, or `PLAN.md`. Look at the branch name, the PR title and body, and the task lines (`T-N`) they reference. They are the agreed scope — without them you cannot judge missing or extra implementation.

## Axes

Every finding belongs to exactly one axis.

1. **bug** — it breaks what the PR intends: wrong logic, unhandled null/error, race, off-by-one, data loss, missing transaction, leaked resource, N+1.
2. **side-effect** — behavior that changed outside the intended scope: a caller or consumer relying on the old behavior, shared state or configuration, a migration touching existing data, performance, another repository.
3. **gap** — implemented, but not all the way: edge case, empty state, permission, validation, error path, missing test for a stated criterion.
4. **missing** — the spec or tasks ask for it and the PR does not deliver it. Cite the requirement (`R<n>`) or task (`T-<n>`).
5. **extra** — implemented beyond the agreed scope: code the documents never asked for, speculative generality, an unused flag, an unrelated refactor riding along.
6. **reuse** — a copy of something that already exists. Say where the existing one lives.

- MUST: Report a finding only when it causes wrong behavior, fails a criterion, breaks something elsewhere, or adds or misses scope.
- DON'T: Report nitpicks — style, naming, formatting, preference, "could be cleaner". If it changes no behavior and no scope, it is not a finding.

## Reviewers

You review nothing yourself. Four sub-agents do, each starting from nothing but the PR number, the document paths and its axes:

- **Criteria** — every acceptance criterion of the tasks this PR delivers, marked ✅ met, ❌ not met or ➖ not in this PR, with `file:line` evidence. Every ❌ becomes a `missing` or `gap` finding; this sub-agent also owns the `gap` and `missing` axes beyond the stated criteria.
- **Bugs** — the `bug` axis.
- **Side effects** — the `side-effect` axis.
- **Scope** — the `extra` and `reuse` axes.

Every sub-agent reads the same way:

- Get the diff with `gh pr diff <n> --patch`, and read the current code around it. A diff hides its context: the caller that breaks, the sibling that already does this, the interface the new code was supposed to implement.
- Open every file the diff touches at its current state, plus the code that calls it and the code it calls.
- Look for the existing thing before calling something a duplicate.

Rules:

- MUST: Dispatch the four in a single message, each with no context — only the PR number, the document paths and its axes. No conversation, no summary, no hint of the answer you expect.
- MUST: Check nothing yourself. You consolidate and report; the sub-agents find.
- MUST: Discard a finding a sub-agent can't back with a `file:line` — or, for `missing`, the requirement or task it cites. An unverified suspicion is noise, not a finding.
- MUST: When two sub-agents disagree, give both claims to a fresh isolated sub-agent and take its verdict from the code.

## Report

Report in the session, in this order:

1. **Verdict** — 🔴 *needs fixes* when there is a `bug`, a `side-effect` or a ❌ criterion; 🟢 *clean* otherwise.
2. **Criteria** — the table: criterion, task, ✅ / ❌ / ➖, evidence.
3. **Findings** — numbered, grouped by axis. Each one: `file:line`, what is wrong, why, and the suggested fix — a short code snippet when the fix is a few lines.
4. **Checked and cleared** — what the diff invited suspicion about and turned out fine. Silence reads as "not looked at".

```
🔴 needs fixes

| Criterion | Task | | Evidence |
|---|---|---|---|
| Export runs in the background | T-2 | ✅ | app/jobs/export_job.rb:12 |
| User is notified when it's ready | T-3 | ❌ | no notification is sent |

**bug**

1. app/jobs/export_job.rb:31 — the file handle is never closed when the upload fails.
   Why: every failed export leaks a descriptor until the worker restarts.
   Fix: close it in an `ensure` around the upload.
```

- MUST: Number the findings and keep the numbers stable — `/plan` and I refer to them by number.
- MUST: Report a repeated finding once, on its clearest occurrence, and list the other places in it.
- MUST: End, when there is any finding, by suggesting `/plan <PR>` to turn the findings into a fix plan.

## Rules

- DON'T: Comment on the PR, submit a review, or reply to anything on it. The report lives in the session only.
- DON'T: Change code, commit, push, merge, close, label or re-title the PR.
- DON'T: Invent a finding to look thorough. A clean PR gets 🟢 and what was checked.
- DON'T: Ask a question the code can answer. A sub-agent reads it and states the finding.

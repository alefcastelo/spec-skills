---
name: implement
description: Implement a spec's or plan's tasks end-to-end
model: claude-sonnet-5
effort: max
---

Implement the tasks for this spec or plan, or pick the next track when none is given: $ARGUMENTS

## Picking

A track is a `TASK.md` or a `PLAN.md` — same checkbox, blocked-by and commit format, same rules below.

- If $ARGUMENTS names a spec (spec dir, `SPEC.md`, `TASK.md`, or a task that belongs to one), implement **all** of its tasks.
- If $ARGUMENTS names a plan (a standalone `specs/{slug}/PLAN.md` or a nested `specs/{spec-slug}/plans/{plan-slug}/PLAN.md`, its directory, or a task that belongs to one), implement **all** of its tasks.
- If $ARGUMENTS names a single task with no spec, implement just that one.
- Otherwise read the `TASK.md` and `PLAN.md` files under `specs/` — nested `plans/` included — and pick the track whose tasks have all their blockers done.

## Autonomy

- MUST: Run unattended, start to finish. Never ask permission to continue, never pause for confirmation between tasks, waves, or slices — the run is expected to complete overnight with nobody watching.
- MUST: State decisions (sizing, wave plan) as a brief note and proceed immediately. A statement is not a question; do not wait for a reply.
- MUST: When something blocks a task, record it under **Open**, skip that task and everything blocked by it, and keep going with every task that remains unblocked. Halt the whole run only when literally nothing can proceed.
- MUST: If a verification pipeline flakes on something unrelated to your change, re-run it; don't stop to ask and don't bypass it.
- MUST: Never end a turn idle while the run is incomplete. Waiting on an agent's pending verification is not a reason to stall the run — dispatch every slice whose blockers are code-complete, chase agents for their results, and reconcile later if a verification comes back red. An end-of-turn status note that reads like "waiting for X" without having dispatched all dispatchable work counts as asking permission — forbidden.

## Sizing

- MUST: Size the run from `TASK.md` before you start, and note which path you're taking and why — then proceed without waiting.
- MUST: Fan out to parallel agents when the spec is medium to big — more than one slice, or more than a handful of tasks.
- SHOULD: Delegate implementation to subagents even for a small spec — the main agent orchestrates and verifies, keeping its own context clean. Implement in the main agent only when the change is trivial (one task, few files).

## Fan-out

- MUST: Dispatch one agent per slice — the tasks in a slice touch the same files, so they belong to the same agent, in dependency order.
- MUST: Work in waves. A wave is every slice whose blockers outside it are already implemented.
- MUST: Dispatch the whole wave in a single message so its agents run concurrently, and wait for all of them before computing the next wave.
- MUST: Keep `TASK.md` yours. Agents report back; you flip the checkbox. Two agents writing that file clobber each other.
- CAN: Split a slice across agents when it's large and its tasks don't touch the same files.
- DON'T: Start a task whose blockers aren't implemented yet.
- DON'T: Implement anything yourself while a wave is running — you orchestrate and verify.

## Execution

- MUST: Read the spec's `SPEC.md` first. Each task points at a requirement (`R1`, `R2`, …) whose acceptance criteria and technical design live there — implement the design we agreed on, don't redesign it. Every agent you dispatch reads it too.
- MUST: For a plan, read the `PLAN.md` itself as that context — it carries its own requirements and acceptance criteria — plus the owning `SPEC.md` when the plan references it. Flip the checkboxes and fill the commit references in the `PLAN.md`, same format.
- MUST: Read the project's `docs/learnings/INDEX.md` when it has one before implementing, opening `docs/learnings/{slug}/{slug}.md` for the ones that touch this work, and pass the relevant learnings to every agent you dispatch.
- MUST: One task at a time within an agent, in dependency order. Finish a task's code before starting the next.
- MUST: Write each task's acceptance criteria into code — the assertion, the endpoint, the file — as written. The criteria define what to build; whether they hold is settled by the slice's verification run, not by a suite per task.
- MUST: Commit **once** at the end, after the last task, with the hook (plain `git commit`) so the full pipeline validates every change. It must be green.

## Handover

- MUST: Finish by pushing the branch and opening the PR, with a description that carries the before/after numbers and the per-file lists a light review needs.
- MUST: **Stop there.** Do not watch the CI, do not fix a failing pipeline, do not review your own work — the agent that wrote the code is the worst judge of it, it will confirm what it meant instead of reading what it wrote.
- MUST: End by telling the user the PR is open.

## Verification

- MUST: Run the suite **per deliverable** — one run per slice / wave / coherent group of changes. Not per task, not per subagent. A slice is the unit that has to hold together, so it's the unit worth a suite.
- MUST: When you do run it, run **every project's suite**, not just the one you edited. Catching a regression the change caused in a sibling project is exactly what the gating run is for — a contract change in the backend breaks the frontend and the mobile app, and only a full run says so.
- MUST: Fix any regression before the slice is called done.
- SHOULD: While developing, run the specific spec/feature files the change touches, in the project you're editing — that's for orienting yourself, and it's cheap. Scoped runs never gate; the full per-deliverable run does.
- DON'T: Gate every task on a full suite. On a big spec that serializes into hours of wall-clock for no extra safety — the deliverable-level run plus the final commit pipeline already covers it.
- DON'T: Let two agents run the same project's suite concurrently when the test runner boots its own server or fixture container — they collide. Serialize that project's work through one agent instead.

## Tracking

- MUST: Update the task's line in `TASK.md` the moment it's done — mark it `- [x]`. Don't batch this to the end.
- MUST: Keep `TASK.md` accurate. It's the live source of truth, so progress is readable from the file at any point.
- MUST: Leave a task `- [ ]` when it can't meet its criteria, note the blocker under **Open**, and don't mark it done.
- MUST: If implementing reveals the design is wrong or a requirement is underspecified, note it under **Open** with what you found, skip the affected tasks, and continue with the rest — don't decide it yourself and don't halt the run for it. Surface everything under **Open** in your final report.

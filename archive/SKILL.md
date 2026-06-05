---
name: archive
description: Archive an executed spec
---

## Completion check

- Read `tasks.md`. A plan is complete only when every task is `- [x]` and the **Open** section is empty.
- If any task is `- [ ]` or **Open** is non-empty, do NOT archive. List the unfinished tasks and open items, then stop.

## Archive

- Resolve today's date as `YYYY-MM-DD` (run `date +%F`).
- Move the whole plan directory to `$PWD/specs/archive/{date}-{slug}/` with `mv`, so archives sort chronologically.
- Never delete — archiving is a move, always reversible by moving it back.
- If `specs/archive/{date}-{slug}/` already exists, stop and ask rather than overwriting.

## Self Improvement

- If we took a architectural decision it should be record

## Summary

Write `$PWD/specs/archive/{date}-{slug}/summary.md`:

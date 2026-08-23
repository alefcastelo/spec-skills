# spec-skills

Spec-driven skills for Claude Code, synced across machines. Source of truth for the eleven skills installed into `~/.claude/skills`.

## The flow

| Skill | Role |
|---|---|
| `/research` | Collaborative external research: validate hypotheses against sources, devil's advocate, living document in `docs/research/{slug}.md` that feeds a PRD/spec |
| `/specify` | Full feature: interview until shared understanding, produce `specs/{slug}/SPEC.md` |
| `/write-tasks` | Break an agreed spec into slices/tasks → `TASK.md` |
| `/plan` | Light sibling of `/specify` for refactorings, fixes, simple changes → a single `PLAN.md` (standalone or nested in a spec); also turns PR review comments into a correction plan |
| `/validate` | Optional pre-implementation check of a SPEC/PLAN against gaps and the real code; approved corrections folded into the doc itself |
| `/implement` | Execute a track (`TASK.md` or `PLAN.md`) end-to-end, in waves of parallel agents |
| `/review` | Review a PR and post inline + summary comments on it (`COMMENT` or `REQUEST_CHANGES`, never `APPROVE`) |
| `/architecture-review` | Validate changed code against the architecture guidelines and report violations (sub-agent dispatched by `/review`) |
| `/never-again` | Validate changed code against recorded learnings and report repeated mistakes (sub-agent dispatched by `/review`) |
| `/learning` | Gatekeeper for `docs/learnings/`: validates candidates, stores only with approval, manages supersedes |
| `/archive` | Move a finished spec/plan to `specs/archive/` (research docs to `docs/research/archive/`); running the `/learning` flow is mandatory |

Learnings live at two levels — global `~/.claude/learnings/` and per project `docs/learnings/` — each an `INDEX.md` (1–2 lines per active learning) + `{slug}/{slug}.md`.

## Install / update on a machine

Requires an authenticated `gh` CLI (the repo is private):

```sh
gh api repos/alefcastelo/spec-skills/contents/install.sh --jq .content | base64 -d | bash
```

Replaces only the eleven skills above in `~/.claude/skills`; any other skill directory is left untouched.

## Editing

Edit here, push to `main`, run the installer on the other machines.

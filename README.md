# spec-skills

Spec-driven skills for Claude Code, synced across machines. Source of truth for the eight skills installed into `~/.claude/skills`.

## The flow

| Skill | Role |
|---|---|
| `/specify` | Full feature: interview until shared understanding, produce `specs/{slug}/SPEC.md` |
| `/write-tasks` | Break an agreed spec into slices/tasks → `TASK.md` |
| `/plan` | Light sibling of `/specify` for refactorings, fixes, simple changes → a single `PLAN.md` (standalone or nested in a spec); also turns PR review comments into a correction plan |
| `/validate` | Optional pre-implementation check of a SPEC/PLAN against gaps and the real code; approved corrections folded into the doc itself |
| `/implement` | Execute a track (`TASK.md` or `PLAN.md`) end-to-end, in waves of parallel agents |
| `/review` | Review a PR and post inline + summary comments on it (`COMMENT` or `REQUEST_CHANGES`, never `APPROVE`) |
| `/learning` | Gatekeeper for `docs/learnings/`: validates candidates, stores only with approval, manages supersedes |
| `/archive` | Move a finished spec/plan to `specs/archive/`; running the `/learning` flow is mandatory |

Learnings live per project in `docs/learnings/INDEX.md` (1–2 lines per active learning) + `docs/learnings/{slug}/{slug}.md`.

## Install / update on a machine

Requires an authenticated `gh` CLI (the repo is private):

```sh
gh api repos/alefcastelo/spec-skills/contents/install.sh --jq .content | base64 -d | bash
```

Replaces only the eight skills above in `~/.claude/skills`; any other skill directory is left untouched.

## Editing

Edit here, push to `main`, run the installer on the other machines.
